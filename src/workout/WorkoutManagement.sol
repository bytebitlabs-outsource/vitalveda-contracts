// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "../RoleManagement.sol";

contract WorkoutManagement is EIP712, RoleManagement {
    constructor(string memory name_, string memory version_) EIP712(name_, version_) {}

    function buy() external {
        
    }
}