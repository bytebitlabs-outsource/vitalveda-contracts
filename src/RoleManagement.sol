// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import "forge-std/console2.sol";

contract RoleManagement is AccessControl {

    bytes32 public constant GOVERNOR = keccak256("ROLE_GOVERNOR");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(GOVERNOR, _msgSender());
    }

    // modifiers
    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Admin only");
        _;
    }

    modifier onlyGovernor() {
        require(hasRole(GOVERNOR, _msgSender()), "Governor only");
        _;
    }
}
