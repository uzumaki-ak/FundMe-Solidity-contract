// SPDX-License-Identifier: MIT


pragma solidity ^0.8.24;

import {PriceConvertor} from './PriceConverter.sol';


//old method to get pricr👇

// solhint-disable-next-line interface-starts-with-i
// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   function getRoundData(
//     uint80 _roundId
//   ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

//   function latestRoundData()
//     external
//     view
//     returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
// }



contract FundMe {
    using PriceConvertor for uint256;
    // uint256 public myval=1;
    uint256 public minimumUSD = 5 * 1e18;
    address[] public funders;
     mapping (address funder => uint256 funded) public addressToAmountFunded;
  address public owner;
  constructor() payable{
    owner = msg.sender;
  }
    function fund() public payable {
        //alllow user ot send money
        //have a minimum usd dol  sent
        //to get the value of that bc 
        //1e18 is 1000000000000000000
        //1e18 is 1 eth
        //1e17 is 0.1 eth
        // require is used to set min amout which is needed ot be  sent
         // if the amount is less than 1e18 it will revert
         // msg.value is the amount of eth sent by the user
        //  myval = myval+2;
        //made our own library and imported and used it 
        require(msg.value.getConversionRate() >= minimumUSD, "minimum amount required");
        //receiving sender naame
        funders.push(msg.sender);
        //getting to know about who funded how much
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

function withdraw() public onlyOwner{

    //ensuring no one else can call withdraw func
    ///we can't be using this one if there are 100s of func which need it so we usse what called modifier
    // require(msg.sender == owner, 'failed no owner');
    for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex ++) {
      address funder = funders[funderIndex];
      addressToAmountFunded[funder]=0;
    
    }
    //resetting the array
funders=new address[](0);

//transfer method
//three transfer,send,call
//transfer thisis now depreceated
// payable(msg.sender).transfer(address(this).balance);
// 2.send this return bol and req to use 'require' keyword to refund ekse wont refund
// this 'send' is deprecated and scheduled for removal. 
// bool sendSuccuess = payable(msg.sender).send(address(this).balance);
// require(sendSuccuess,"failed");


//3.call this is recommended this has some good and adv usage but here we will use to send transaction only this reurns 2 val callSuccess and dataReturnes

(bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
require(callSuccess,"failed");
} 
 
modifier onlyOwner() {
    require(msg.sender == owner , 'not owner');
    _;

    //the order of thi underscore "_" maters if it was above then it would mean that execute all func first then this onlyowner but now it is exec onlyowner first then only withdraw func
}
}
