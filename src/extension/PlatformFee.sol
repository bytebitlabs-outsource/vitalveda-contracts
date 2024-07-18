// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

abstract contract PlatformFee {

    event FeeChanged(uint256 newFee, address indexed changedBy);

    error InvalidFee(uint256 fee);

    uint256 private _fee;

    constructor(uint256 fee_) {
        _setFee(fee_);
    }

    function _setFee(uint256 fee_) internal virtual {
        if (fee_ > 10_000 ether) {
            revert InvalidFee(fee_);
        }

        _fee = fee_;

        emit FeeChanged(fee_, msg.sender);
    }

    /**
     * @dev Returns the fee.
     */
    function fee() public view virtual returns (uint256) {
        return _fee;
    }
}
