// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


struct swapp {
    address owner;
    uint256 decimal;
    IERC20 token1;
    IERC20 token2;
    AggregatorV3Interface  pricefeeddai;
     AggregatorV3Interface  pricefeedusd;
    AggregatorV3Interface  pricefeedeth;
    AggregatorV3Interface  pricefeedbat;
}