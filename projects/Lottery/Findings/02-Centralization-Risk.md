# Medium - Centralization Risk

## Severity

Medium

## Description

Only the manager can call the `pickwinner()` function. Players have no control over when the lottery is finalized.

## Affected Code

```solidity
function pickwinner() public {
    require(manager == msg.sender, "You are not manager");
}
```

## Impact

If the manager never calls the function, user's funds remain locked in the contract.
