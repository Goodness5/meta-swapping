// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "../../lib/openzeppelin-contracts/contracts/metatx/ERC2771Context.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "../../lib/metatx-standard/src/contracts/EIP712MetaTransaction.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {swapp}  from "./libswappingData.sol";

library libSwapper{



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
        uint256 daiPriceInBat = daiPriceInUsd * ds.decimal / batPriceInUsd;
        uint256 amountToReceive = _amounttoswap * daiPriceInBat / ds.decimal;
        bool success = ds.token1.approve(address(this), _amounttoswap);
        bool deduct = ds.token1.transferFrom(msg.sender, address(this), _amounttoswap);
        bool pay =  ds.token2.transfer(msg.sender, amountToReceive);
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
        uint256 daiPriceInbat = batPriceInUsd * ds.decimal / daiPriceInUsd;
        uint256 amountToReceive = _amounttoswap * daiPriceInbat / ds.decimal;
        bool success = ds.token1.approve(address(this), _amounttoswap);
        bool deduct = ds.token2.transferFrom(msg.sender, address(this), _amounttoswap);
        bool pay =  ds.token1.transfer(msg.sender, amountToReceive);
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
        uint256 batPriceInEth = ethPriceInUsd * ds.decimal / batPriceInUsd;
        uint256 amountToReceive = _amounttoswap * batPriceInEth / ds.decimal;
        bool deduct = msg.value == _amounttoswap;
        address payable recipient = payable(address(this));
        recipient.transfer(msg.value);
            bool pay = ds.token1.transferFrom(msg.sender, address(this), amountToReceive);
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
        uint256 batPriceInEth = batPriceInUsd * ds.decimal / ethPriceInUsd;
        uint256 amountToReceive = _amounttoswap * batPriceInEth / ds.decimal;
        bool success = ds.token1.approve(address(this), _amounttoswap);
        bool deduct = ds.token1.transferFrom(msg.sender, address(this), _amounttoswap);
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
            success = IERC20(_tokenaddress).transfer(msg.sender, amt);
            return success;
      }
    function withdrawERC721token(address _tokenaddress, uint _tokenid) internal returns (bool success) {
        // AssetData storage ds = AssetSlot();
        address owner = IERC721(_tokenaddress).ownerOf(_tokenid);
        require(owner==address(this), "token not available");
        IERC721(_tokenaddress).transferFrom(address(this), msg.sender, _tokenid);
        success = true;
        return success;
    }

      function swapperSlot() internal pure returns(swapp storage ds) {
        assembly {
            ds.slot := 0
        }
      
}

}