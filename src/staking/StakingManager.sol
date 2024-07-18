// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import {RoleManagement} from "../RoleManagement.sol";
import {IPlatformStaking} from "./IPlatformStaking.sol";

contract StakingManager is RoleManagement, IPlatformStaking {
    constructor() {}
}
