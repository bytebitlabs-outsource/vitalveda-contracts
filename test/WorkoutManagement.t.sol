// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "../src/VVFit.sol";
import "../src/FeeManagement.sol";
import "../src/workout/WorkoutManagement.sol";

contract WorkoutManagementTest is Test {

    VVFit private vvfit;
    WorkoutManagement wm;
    FeeManagement fm;
    uint256 signerPrivateKey = 0x64b507b37b841fbc82407b3b8a24ade931890cb3285b10d4f90012799d84c46d;
    address signer = vm.addr(signerPrivateKey);

    function setUp() public {
        vvfit = new VVFit("Vital VEDA", "VVFIT");
        fm = new FeeManagement();
        fm.setCurrency(vvfit);
        wm = new WorkoutManagement("Workout", "1");
        wm.setFeeManagement(fm);
        wm.setSigner(signer);
    }

    function test_Buy() public {
        // mint vvfit to sender
        vvfit.mint(address(this), 100 ether);

        // buy workout message
        //// workoutID 1 
        //// userID 1
        BuyWorkout memory req = BuyWorkout({
            wid: 1,
            fee: 5 ether,
            currency: address(vvfit),
            uid: 1,
            nonce: 1,
            deadline: block.number + 50
        });

        // gen hash
        bytes32 digest = MessageHashUtils.toTypedDataHash(
            wm.getDomainSeparator(), 
            keccak256(abi.encode(
                wm.BUY_WORKOUT_TYPEHASH(),
                req.wid,
                req.fee,
                req.currency,
                req.uid,
                req.nonce,
                req.deadline
            ))
        );

        // gen signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        // simulate frontend call
        // approve fee
        vvfit.approve(address(wm), req.fee);
        
        // simulate buy
        assertTrue(wm.buy(req, signature));
        // test ownership checking
        assertTrue(wm.isOwnerOf(1, 1));
        // test wm's vvfit balance
        assertEq(vvfit.balanceOf(address(wm)), req.fee);
    }

    function test_BuySignerNotMatched() public {
        // buy workout message
        BuyWorkout memory req = BuyWorkout({
            wid: 1,
            fee: 5 ether,
            currency: address(vvfit),
            uid: 1,
            nonce: 1,
            deadline: block.number + 50
        });

        // gen hash
        bytes32 digest = MessageHashUtils.toTypedDataHash(
            wm.getDomainSeparator(), 
            keccak256(abi.encode(
                wm.BUY_WORKOUT_TYPEHASH(),
                req.wid,
                req.fee,
                req.currency,
                req.uid,
                req.nonce,
                req.deadline
            ))
        );

        // gen signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(0x1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        
        // simulate buy
        vm.expectRevert(bytes("Signer not matched"));
        wm.buy(req, signature);
    }

    function test_BuyInvalidNonce() public {
        // mint vvfit to sender
        vvfit.mint(address(this), 100 ether);

        // buy workout message
        //// workoutID 1 
        //// userID 1
        BuyWorkout memory req = BuyWorkout({
            wid: 1,
            fee: 5 ether,
            currency: address(vvfit),
            uid: 1,
            nonce: 1,
            deadline: block.number + 50
        });

        // gen hash
        bytes32 digest = MessageHashUtils.toTypedDataHash(
            wm.getDomainSeparator(), 
            keccak256(abi.encode(
                wm.BUY_WORKOUT_TYPEHASH(),
                req.wid,
                req.fee,
                req.currency,
                req.uid,
                req.nonce,
                req.deadline
            ))
        );

        // gen signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        // simulate frontend call
        // approve fee
        vvfit.approve(address(wm), req.fee);
        // simulate buy
        wm.buy(req, signature);

        // another buy with the same nonce
        // approve fee
        vvfit.approve(address(wm), req.fee);
        // simulate buy
        vm.expectRevert(bytes("Invalid nonce"));
        wm.buy(req, signature);
    }

    function test_BuyExpiredMessage() public {
        // buy workout message
        //// workoutID 1 
        //// userID 1
        BuyWorkout memory req = BuyWorkout({
            wid: 1,
            fee: 5 ether,
            currency: address(vvfit),
            uid: 1,
            nonce: 1,
            deadline: block.number - 1
        });

        // gen hash
        bytes32 digest = MessageHashUtils.toTypedDataHash(
            wm.getDomainSeparator(), 
            keccak256(abi.encode(
                wm.BUY_WORKOUT_TYPEHASH(),
                req.wid,
                req.fee,
                req.currency,
                req.uid,
                req.nonce,
                req.deadline
            ))
        );

        // gen signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        // simulate frontend call
        // simulate buy
        vm.expectRevert(bytes("Expired message"));
        wm.buy(req, signature);
    }

    function test_BuyInvalidCurrency() public {
        // buy workout message
        //// workoutID 1 
        //// userID 1
        BuyWorkout memory req = BuyWorkout({
            wid: 1,
            fee: 5 ether,
            currency: address(1),
            uid: 1,
            nonce: 1,
            deadline: block.number + 50
        });

        // gen hash
        bytes32 digest = MessageHashUtils.toTypedDataHash(
            wm.getDomainSeparator(), 
            keccak256(abi.encode(
                wm.BUY_WORKOUT_TYPEHASH(),
                req.wid,
                req.fee,
                req.currency,
                req.uid,
                req.nonce,
                req.deadline
            ))
        );

        // gen signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        // simulate frontend call
        // simulate buy
        vm.expectRevert(bytes("Invalid currency"));
        wm.buy(req, signature);
    }

    function test_BuyInvalidPaymentAmount() public {
        // mint vvfit to sender
        vvfit.mint(address(this), 100 ether);

        // buy workout message
        //// workoutID 1 
        //// userID 1
        BuyWorkout memory req = BuyWorkout({
            wid: 1,
            fee: 5 ether,
            currency: address(vvfit),
            uid: 1,
            nonce: 1,
            deadline: block.number + 50
        });

        // gen hash
        bytes32 digest = MessageHashUtils.toTypedDataHash(
            wm.getDomainSeparator(), 
            keccak256(abi.encode(
                wm.BUY_WORKOUT_TYPEHASH(),
                req.wid,
                req.fee,
                req.currency,
                req.uid,
                req.nonce,
                req.deadline
            ))
        );

        // gen signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        // simulate frontend call
        // approve fee
        vvfit.approve(address(wm), 1 ether);
        
        // simulate buy
        vm.expectRevert(bytes("Invalid payment amount"));
        wm.buy(req, signature);
    }
}