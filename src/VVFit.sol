// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {RoleManagement} from "./RoleManagement.sol";

contract VVFit is ERC20, ERC20Capped, RoleManagement {

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) ERC20Capped(100_000_000 ether) RoleManagement() {}

    // implemented functions
    function mint(address to, uint256 amount) public virtual onlyAdmin {
        _mint(to, amount);
    }

    // overrides parent contracts
    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Capped) {
        super._update(from, to, value);
    }
}
