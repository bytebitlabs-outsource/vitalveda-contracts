// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import "../src/VVFit.sol";
import "../src/FeeManagement.sol";
import "../src/workout/WorkoutManagement.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        VVFit vvfit = new VVFit("Vital VEDA", "VVFIT");
        FeeManagement fm = new FeeManagement();
        fm.setFee(5 ether);
        fm.setCurrency(vvfit);
        WorkoutManagement wm = new WorkoutManagement("Workout", "1");
        wm.setFeeManagement(fm);
        wm.setSigner(vm.addr(vm.envUint("PRIVATE_KEY")));

        vm.stopBroadcast();
    }
}
