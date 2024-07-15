// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import "forge-std/console2.sol";

contract RoleManager is AccessControl {

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
