// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

library MathLib {
    function calculateFeeBps(uint256 amount_, uint256 feeBps_) external pure returns (uint256) {
        return (amount_ * feeBps_) / 10_000;
    }
}
