// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import {RoleManagement} from "../RoleManagement.sol";
import {IPlatformTreasury} from "./IPlatformTreasury.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TreasuryManagement is RoleManagement, IPlatformTreasury {

    IERC20 public currency;

    constructor(address currency_) RoleManagement() {
        currency = IERC20(currency_);
    }

    function deposit(uint256 amount_) external override returns (bool) {
        require(currency.allowance(_msgSender(), address(this)) >= amount_, "Approve not enough amount");
        return currency.transferFrom(_msgSender(), address(this), amount_);
    }

    function balance() external view override returns (uint256) {
        return currency.balanceOf(address(this));
    }

    function move(address to_, uint256 amount_) external onlyGovernor {
        currency.transfer(to_, amount_);
    }
}
