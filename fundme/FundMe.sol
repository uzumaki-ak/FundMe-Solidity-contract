// SPDX-License-Identifier: MIT


pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


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
    
    // uint256 public myval=1;
    uint256 public minimumUSD = 5 * 1e18;
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
        require(getConversionRate(msg.value) >= minimumUSD, "minimum amount required");
    }

// function withdraw() public{} 
 function getVersion() public view returns (uint256) {
return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
 }

 function  getPrice() public view returns(uint256) {
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
     (,int256 price , , ,) = priceFeed.latestRoundData();
    return uint256(price * 1e10);
 }
 function getConversionRate(uint256 ethAmount) public view returns(uint256) {
    uint256 ethPrice = getPrice();
  uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
  return ethAmountInUsd;
 }

}
