// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

interface IPlatformTreasury {
    function deposit(uint256 amount_) external returns(bool);

    function balance() external view returns (uint256);
}
