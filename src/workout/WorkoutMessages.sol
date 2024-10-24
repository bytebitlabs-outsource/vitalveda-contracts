// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

struct BuyWorkout {
    uint256 wid;
    uint256 fee;
    address currency;
    uint256 uid;
    uint256 nonce;
    uint256 deadline;
}