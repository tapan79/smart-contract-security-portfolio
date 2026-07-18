# Low - Hardcoded Entry Fee

## Severity

Low

## Description

The participantion fee is fixed at exactly 1 Ether.

```solidity
require(msg.value == 1 ether);
```

## Impact

The manager cannot change the participation fee without redeploying the contract.
