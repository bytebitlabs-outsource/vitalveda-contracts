// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../RoleManagement.sol";
import "../FeeManagement.sol";
import "./WorkoutMessages.sol";

contract WorkoutManagement is EIP712, RoleManagement {
    address _signer;
    FeeManagement _feeManagement;
    // users nonce
    mapping (uint256 => uint256) _nonce;
    // mapping workout ID to buyer IDs
    mapping (uint256 => uint256[]) _buyers;

    // typehashes
    bytes32 public constant BUY_WORKOUT_TYPEHASH =
        keccak256("BuyWorkout(uint256 wid, uint256 fee, address currency, uint256 uid, uint256 nonce, uint256 deadline)");

    constructor(string memory name_, string memory version_) EIP712(name_, version_) {}

    function getDomainSeparator() public view returns (bytes32) {
        return _domainSeparatorV4();
    }

    function setSigner(address signer_) public onlyAdmin {
        _signer = signer_;
    }

    function getSigner() public view returns (address) {
        return _signer;
    }

    function setFeeManagement(FeeManagement feeManagement_) public onlyAdmin {
        _feeManagement = feeManagement_;
    }

    function isOwnerOf(uint256 wid_, uint256 uid_) public view returns (bool) {
        uint256[] storage workoutBuyers = _buyers[wid_];
        for (uint i = 0; i < workoutBuyers.length; i++) {
            if (workoutBuyers[i] == uid_) {
                return true;
            }
        }
        return false;
    }

    function buy(BuyWorkout memory message_, bytes memory sigature_) external returns (bool) {
        // validate message
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            BUY_WORKOUT_TYPEHASH,
            message_.wid,
            message_.fee,
            message_.currency,
            message_.uid,
            message_.nonce,
            message_.deadline
        )));

        address signer = ECDSA.recover(digest, sigature_);
        require(signer == _signer, "Signer not matched");

        // validate nonce
        require(message_.nonce > _nonce[message_.uid], "Invalid nonce");
        // update to the latest nonce
        _nonce[message_.uid] = message_.nonce;

        // validate deadline
        require(message_.deadline >= block.number, "Expired message");

        // validate currency
        IERC20 currency = _feeManagement.currency();
        require(message_.currency == address(currency), "Invalid currency");

        // validate payment
        require(message_.fee <= currency.allowance(msg.sender, address(this)), "Invalid payment amount");
        require(currency.transferFrom(msg.sender, address(this), message_.fee), "Failed to deposit");

        // persist buy's info
        if (!isOwnerOf(message_.wid, message_.uid)) {
            uint256[] storage workoutBuyers = _buyers[message_.wid];
            workoutBuyers.push(message_.uid);
        }

        return true;
    }
}