// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "../../lib/openzeppelin-contracts/contracts/metatx/ERC2771Context.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../lib/metatx-standard/src/contracts/EIP712MetaTransaction.sol";
import { IERC20 } from "../interfaces/IToken.sol";
import {swapp}  from "./libswappingData.sol";

library libSwapper is ERC2771Context{



    function getLatestPrice (AggregatorV3Interface pricefeed) internal view returns (uint80 roundID, int price,
        uint  startedAt,uint timeStamp,uint80 answeredInRound) {
        (roundID, price,startedAt,timeStamp,answeredInRound) = pricefeed.latestRoundData();
    } 


    function swapDaiToBat(uint256 _amounttoswap) internal returns(bool swapped){
        // require(gasleft() >= MIN_GAS, "Not enough gas provided");
        // if (gasleft() < MIN_GAS) {
        //     EIP712MetaTransaction.
        //   EIP712MetaTransaction.executeMetaTransaction(EIP712MetaTransaction.msgSenser());
        // }
          swapp storage ds = swapperSlot();
        (, int daiPrice, , , ) = getLatestPrice(ds.pricefeeddai);
        (, int batPrice, , , ) = getLatestPrice(ds.pricefeedbat);
        uint256 daiPriceInUsd = uint256(daiPrice);
        uint256 batPriceInUsd = uint256(batPrice);
        uint256 daiPriceInBat = daiPriceInUsd * decimal / batPriceInUsd;
        uint256 amountToReceive = _amounttoswap * daiPriceInBat / decimal;
        bool success = token1.approve(address(this), _amounttoswap);
        bool deduct = token1.transferFrom(msgSennder(), address(this), _amounttoswap);
        bool pay =  token2.transfer(msgSennder(), amountToReceive);
        require(deduct, "Transfer of token1 failed");
        require(pay, "Transfer of token2 failed");
        require(success, "Approval of Dai failed");
        swapped = true;
    }



    function swapBatToDai(uint256 _amounttoswap) internal returns(bool swapped){
            //  if (gasleft() < MIN_GAS) {
        //     EIP712MetaTransaction.
        //   EIP712MetaTransaction.executeMetaTransaction(EIP712MetaTransaction.msgSenser());
        // }
          swapp storage ds = swapperSlot();
        (, int daiPrice, , , ) = getLatestPrice(ds.pricefeeddai);
        (, int batPrice, , , ) = getLatestPrice(ds.pricefeedbat);
        uint256 batPriceInUsd = uint256(batPrice);
        uint256 daiPriceInUsd = uint256(daiPrice);
        uint256 daiPriceInbat = batPriceInUsd * decimal / daiPriceInUsd;
        uint256 amountToReceive = _amounttoswap * daiPriceInbat / decimal;
        bool success = token1.approve(address(this), _amounttoswap);
        bool deduct = token2.transferFrom(msgSennder(), address(this), _amounttoswap);
        bool pay =  token1.transfer(msgSennder(), amountToReceive);
        require(deduct, "Transfer of token1 failed");
        require(pay, "Transfer of token2 failed");
        require(success, "Approval of Bat failed");
        swapped = true;
    }

    function swapEthToBat(uint256 _amounttoswap) internal  returns(bool swapped){
        //      if (gasleft() < MIN_GAS) {
        //     EIP712MetaTransaction.
        //   EIP712MetaTransaction.executeMetaTransaction(EIP712MetaTransaction.msgSenser());
        // }
        swapp storage ds = swapperSlot();
        (, int batPrice, , , ) = getLatestPrice(ds.pricefeedbat);
        (, int ethPrice, , , ) = getLatestPrice(ds.pricefeedeth);
        uint256 ethPriceInUsd = uint256(ethPrice);
        uint256 batPriceInUsd = uint256(batPrice);
        uint256 batPriceInEth = ethPriceInUsd * decimal / batPriceInUsd;
        uint256 amountToReceive = _amounttoswap * batPriceInEth / decimal;
        bool deduct = msg.value == _amounttoswap;
        address payable recipient = payable(address(this));
        recipient.transfer(msg.value);
            bool pay = token1.transferFrom(msgSennder(), address(this), amountToReceive);
        require(deduct, "Transfer of token1 failed");
        require(pay, "Transfer of token2 failed");
        swapped = true;
    }

    function swapBatToEth(uint256 _amounttoswap) internal returns(bool swapped){
        //      if (gasleft() < MIN_GAS) {
        //     EIP712MetaTransaction.
        //   EIP712MetaTransaction.executeMetaTransaction(EIP712MetaTransaction.msgSenser());
        // }
          swapp storage ds = swapperSlot();
        (, int batPrice, , , ) = getLatestPrice(ds.pricefeedbat);
        (, int ethPrice, , , ) = getLatestPrice(ds.pricefeedeth);
        uint256 batPriceInUsd = uint256(batPrice);
        uint256 ethPriceInUsd = uint256(ethPrice);
        uint256 batPriceInEth = batPriceInUsd * decimal / ethPriceInUsd;
        uint256 amountToReceive = _amounttoswap * batPriceInEth / decimal;
        bool success = token1.approve(address(this), _amounttoswap);
        bool deduct = token1.transferFrom(msgSennder(), address(this), _amounttoswap);
        address payable recipient = payable(msg.sender);
        bool pay = false;
        pay = recipient.send(amountToReceive);
        require(success, "Approval of token1 failed");
        require(deduct, "Transfer of token1 failed");
        require(pay, "Transfer of eth failed");
        swapped = true;
    }

         function withdraweth(uint256 _value) internal returns (bool success) {
            // AssetData storage ds = AssetSlot();
     require(address(this).balance >= _value, "insufficient balance");
     address payable reciepient = payable(msg.sender);
     success = reciepient.send(_value);
     require(success, "withdrawal failed");
    }

    function withdrawERC20token(address _tokenaddress) internal returns (bool success) {
            // AssetData storage ds = AssetSlot();
            uint amt = IERC20(_tokenaddress).balanceOf(address(this));
            require(amt > 0, "insuficient balance");
            success = IERC20(_tokenaddress).transfer(msgSennder(), amt);
            return success;
      }
    function withdrawERC721token(address _tokenaddress, uint _tokenid) internal returns (bool success) {
        // AssetData storage ds = AssetSlot();
        address owner = IERC721(_tokenaddress).ownerOf(_tokenid);
        require(owner==address(this), "token not available");
        IERC721(_tokenaddress).transferFrom(address(this), msgSennder(), _tokenid);
        success = true;
        return success;
    }

      function swapperSlot() internal pure returns(swapp storage ds) {
        assembly {
            ds.slot := 0
        }
      
}

}