// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {PlatformFee} from "./extension/PlatformFee.sol";
import {RoleManagement} from "./RoleManagement.sol";
import {MathLib} from "./util/MathLib.sol";

contract FeeManager is PlatformFee, RoleManagement {

    constructor() RoleManagement() PlatformFee(5 ether) {}

    function setFee(uint256 fee_) external virtual onlyAdmin {
        super._setFee(fee_);
    }
}
