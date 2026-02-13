# FundMe Smart Contract

A beginner-friendly Solidity smart contract that allows users to fund the contract with ETH, with a minimum USD requirement. This was your first Solidity contract - congratulations on starting your blockchain journey! 🎉

## Overview

This contract implements a simple crowdfunding mechanism where:

- Users can send ETH to the contract
- Each transaction must meet a minimum USD value (currently 5 USD)
- The contract uses Chainlink oracles to get real-time ETH/USD prices

## Contract Details

| Attribute            | Value   |
| -------------------- | ------- |
| **Solidity Version** | ^0.8.24 |
| **License**          | MIT     |
| **Minimum USD**      | 5 USD   |

## Key Concepts Explained

### 1. Wei (1e18)

```solidity
1e18 = 1,000,000,000,000,000,000 wei = 1 ETH
1e17 = 0.1 ETH
1e16 = 0.01 ETH
```

When working with Solidity, all currency values are in **wei** (the smallest unit of ETH). The `1e18` notation is scientific notation meaning 1 × 10¹⁸.

### 2. Chainlink Price Feeds

The contract uses [Chainlink](https://chain.link/) oracles to get real-time ETH/USD prices. Chainlink is a decentralized oracle network that provides reliable off-chain data to smart contracts.

- **AggregatorV3Interface**: A standard interface for interacting with Chainlink price feeds
- **Price Feed Address**: `0x694AA1769357215DE4FAC081bf1f309aDC325306` (Sepolia testnet ETH/USD)

### 3. `msg.value`

In Solidity, `msg.value` is a special global variable that contains the amount of ETH (in wei) sent with a transaction.

### 4. `require()`

The `require()` function is used for validation. If the condition is false, the transaction reverts (fails) and any changes are undone. It's like an "if not, then stop" statement.

## Contract Functions

### `fund()`

```solidity
function fund() public payable
```

Allows users to send ETH to the contract.

- **Requirements**: The ETH sent must be worth at least 5 USD
- **Payable**: This keyword allows the function to receive ETH
- **Reverts**: If the amount is less than 5 USD worth of ETH

### `getPrice()`

```solidity
function getPrice() public view returns (uint256)
```

Returns the current ETH/USD price.

- Returns the price scaled to 1e18 (for precision in calculations)
- Uses Chainlink's latestRoundData() function

### `getVersion()`

```solidity
function getVersion() public view returns (uint256)
```

Returns the version of the Chainlink price feed being used.

### `getConversionRate(uint256 ethAmount)`

```solidity
function getConversionRate(uint256 ethAmount) public view returns (uint256)
```

Converts a given amount of ETH to its USD equivalent.

- **Input**: Amount of ETH in wei
- **Output**: Equivalent value in USD (scaled by 1e18)

## How It Works

1. **User calls `fund()` and sends ETH**
2. **Contract gets current ETH/USD price** using Chainlink
3. **Calculates USD value** of the sent ETH: `(ethPrice * ethAmount) / 1e18`
4. **Validates**: If USD value ≥ 5 USD, the transaction succeeds
5. **Otherwise**: Transaction reverts with "minimum amount required" error

## Code Flow Diagram

```
User sends ETH
      │
      ▼
┌─────────────────┐
│   fund()        │
│   function      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ getPrice()      │ ◄─── Calls Chainlink
│ (ETH/USD)       │      Price Feed
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ getConversion   │ ◄─── Calculates
│ Rate()          │      USD value
└────────┬────────┘
         │
         ▼
    ┌────┴────┐
    │ >= $5?  │
    └────┬────┘
   Yes   │   No
    │    │
    ▼    ▼
Success Revert
```

## Common Errors for Beginners

### "Transaction reverted"

This happens when you send less than 5 USD worth of ETH. Make sure your wallet is set to send enough ETH!

### Understanding the Price Calculation

```solidity
// Why multiply by 1e10?
// Chainlink returns price with 8 decimals
// We multiply by 1e10 to make it 18 decimals (wei precision)
return uint256(price * 1e10);
```

## Next Steps to Expand This Contract

Once you're comfortable with this contract, you can add:

1. **Withdraw Function**: Allow the owner to withdraw collected funds
2. **Mapping**: Track who funded and how much
3. **Events**: Emit events for better tracking
4. **Modifiers**: Add access control
5. **Reentrancy Guard**: Prevent attack vectors

## Learning Resources

- [Solidity Documentation](https://docs.soliditylang.org/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Patrick Collins' Foundry Course](https://github.com/Cyfrin/foundry-full-course-solidity) - Highly recommended!

## Acknowledgments

This contract was built while learning Solidity. Every expert started as a beginner! 🚀
