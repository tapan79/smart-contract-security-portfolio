# High - Insecure Randomness

## Severity

High

## Description

The Lottery contract generates randomness using:

- block.prevrandao
- block.timestamp
- players.length

These values are predictable to some extent and should not be used for selecting a lottery winner where real value is at stake.

## Affected Code

solidity
uint index = random() % players.length;
