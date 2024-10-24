// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract PlatformFee {

    event FeeChanged(uint256 newFee, address indexed changedBy);
    error InvalidFee(uint256 fee);

    event CurrencyChanged(IERC20 newCurrency, address indexed changedBy);
    error InvalidCurrency(IERC20 currency);

    uint256 private _fee;
    IERC20 private _currency;

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

    function _setCurrency(IERC20 currency_) internal virtual {
        if (address(currency_) == address(0)) {
            revert InvalidCurrency(currency_);
        }

        _currency = currency_;

        emit CurrencyChanged(currency_, msg.sender);
    }

    /**
     * @dev Returns the fee.
     */
    function fee() public view virtual returns (uint256) {
        return _fee;
    }

    /**
     * @dev Returns the currency.
     */
    function currency() public view virtual returns (IERC20) {
        return _currency;
    }
}
