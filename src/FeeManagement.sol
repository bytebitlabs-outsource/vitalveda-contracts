// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {PlatformFee} from "./extension/PlatformFee.sol";
import {RoleManagement} from "./RoleManagement.sol";

contract FeeManagement is PlatformFee, RoleManagement {

    constructor() RoleManagement() PlatformFee(5 ether) {}

    function setFee(uint256 fee_) external virtual onlyAdmin {
        super._setFee(fee_);
    }

    function setCurrency(IERC20 currency_) external virtual onlyAdmin {
        super._setCurrency(currency_);
    }
}
