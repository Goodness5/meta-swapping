// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../../lib/openzeppelin-contracts/contracts/metatx/ERC2771Context.sol";
import "../../lib/openzeppelin-contracts/contracts/metatx/MinimalForwarder.sol";
import "../libraries/libswapper.sol";
// import "../../lib/metatx-standard/src/contracts/EIP712MetaTransaction.sol";
import {swapp}  from "../libraries/libswappingData.sol";

contract SwapperFacet is ERC2771Context, MinimalForwarder{
  constructor (address richkid) ERC2771Context(richkid) {
     swapp storage ds = swapperSlot();
        richkid = address(this);
        ds.pricefeeddai = AggregatorV3Interface(0x773616E4d11A78F511299002da57A0a94577F1f4);
        ds.pricefeedeth = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        ds.pricefeedbat = AggregatorV3Interface(0x0d16d4528239e9ee52fa531af613AcdB23D88c94);
        ds.token1 = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        ds.token2 = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
        

    
    }

    function swapDaiToBat(uint256 _amounttoswap) external returns (bool swapped) {
        // uint256 gasLimit = gasleft();
        // uint256 gasPrice = tx.gasprice;
        // if(gasLimit > gasPrice){
        // libSwapper.swapDaiToBat(_amounttoswap);
        // }else{
        _msgSender();
        libSwapper.swapDaiToBat(_amounttoswap);
        // }
        return swapped;
    }
    function swapBatToDai(uint256 _amounttoswap) external returns (bool swapped) {
        _msgSender();
        libSwapper.swapBatToDai(_amounttoswap);
        return swapped;
    }
    function swapEthToBat(uint256 _amounttoswap) external returns (bool swapped) {
        _msgSender();
        libSwapper.swapEthToBat(_amounttoswap);
        return swapped;
    }
    function swapBatToEth(uint256 _amounttoswap) external returns (bool swapped) {
        _msgSender();
        libSwapper.swapBatToEth(_amounttoswap);
        return swapped;
    }

    function withdraweth(uint256 _value) external returns (bool success) {
        libSwapper.withdraweth(_value);
        return success;
    }
     function withdrawERC20token(address _tokenaddress) external returns (bool success) {
        libSwapper.withdrawERC20token(_tokenaddress);
        return success;
    }
     function withdrawERC721token(address _tokenaddress, uint _tokenid) external returns (bool success) {
        libSwapper.withdrawERC721token(_tokenaddress, _tokenid);
        return success;
    }
         function swapperSlot() internal pure returns(swapp storage ds) {
        assembly {
            ds.slot := 0
        }
      
}
}