// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


struct swapp {
    address owner;
    uint256 decimal = 1e18;
    IERC20 public token1;
    IERC20 public token2;
    AggregatorV3Interface private pricefeeddai;
    //  AggregatorV3Interface private pricefeedusd;
    AggregatorV3Interface private pricefeedeth;
    AggregatorV3Interface private pricefeedbat;
}