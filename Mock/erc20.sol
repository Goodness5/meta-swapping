// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_
    ) ERC20(name_, symbol_){
        name_ = "mock";
        symbol_ = "MK";
        decimals_ = 18;
        totalSupply_=10000 * 10**decimals_;
        _mint(msg.sender, totalSupply_);
    }
}
