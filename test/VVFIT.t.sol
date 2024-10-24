// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import "../src/VVFit.sol";

contract VVFITTest is Test {

    VVFit private vvfit;

    function setUp() public {
        vvfit = new VVFit("Vital VEDA", "VVFIT");
    }

    function test_VVFITSupply() public {
        vvfit.mint(msg.sender, 100 ether);
        assertEq(vvfit.totalSupply(), 100 ether);
        assertEq(vvfit.balanceOf(msg.sender), 100 ether);
    }

    function testFail_VVFITCap() public {
        vvfit.mint(msg.sender, 100_000_001 ether);
    }
}