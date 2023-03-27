// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../lib/openzeppelin-contracts/contracts/metatx/ERC2771Context.sol";
import "../libraries/libswapper.sol";
import "../../lib/metatx-standard/src/contracts/EIP712MetaTransaction.sol";
import "../libraries/libswappingData.sol";

contract SwapperFacet is ERC2771Context {
  constructor (address richkid) ERC2771Context(richkid) {
        richkid = address(this);
            owner = msg.sender;
        pricefeeddai = AggregatorV3Interface(0x773616E4d11A78F511299002da57A0a94577F1f4);
        pricefeedeth = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        pricefeedbat = AggregatorV3Interface(0x0d16d4528239e9ee52fa531af613AcdB23D88c94);
        token1 = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        token2 = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
        

    
    }

    function swapDaiToBat(uint256 _amounttoswap)  returns (bool swapped) {
        libSwapper.swapDaiToBat(_amounttoswap);
        return swapped;
    }
    function swapBatToDai(uint256 _amounttoswap)  returns (bool swapped) {
        libSwapper.swapBatToDai(_amounttoswap);
        return swapped;
    }
    function swapEthToBat(uint256 _amounttoswap)  returns (bool swapped) {
        libSwapper.swapEthToBat(_amounttoswap);
        return swapped;
    }
    function swapBatToEth(uint256 _amounttoswap)  returns (bool swapped) {
        libSwapper.swapBatToEth(_amounttoswap);
        return swapped;
    }
}