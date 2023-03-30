// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/Counter.sol";
import "../contracts/facets/SwapperFacet.sol";

contract swappertest is Test {
    SwapperFacet swapper;
    address richkid = address(this);
    uint256 amount = 1000000000000000000; 
   
function setUp() public {
    swapper = new SwapperFacet(richkid);
}

function testSwapDaiToBat() public {
    // Approve DAI for SwapperFacet contract
    IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    dai.approve(address(swapper), amount);
    
    // Check BAT balance before swap
    IERC20 bat = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
    uint256 batBalanceBefore = bat.balanceOf(address(this));
    
    // Swap DAI to BAT
    swapper.swapDaiToBat(amount);
    
    // Check BAT balance after swap
    uint256 batBalanceAfter = bat.balanceOf(address(this));
    // Assert.notEqual(batBalanceBefore, batBalanceAfter, "BAT balance should have increased after swap");
}

function testSwapBatToDai() public {
    // Approve BAT for SwapperFacet contract
    IERC20 bat = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
    bat.approve(address(swapper), amount);
    
    // Check DAI balance before swap
    IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    uint256 daiBalanceBefore = dai.balanceOf(address(this));
    
    // Swap BAT to DAI
    swapper.swapBatToDai(amount);
    
    // Check DAI balance after swap
    uint256 daiBalanceAfter = dai.balanceOf(address(this));
    // Assert.notEqual(daiBalanceBefore, daiBalanceAfter, "DAI balance should have increased after swap");
}

function testSwapEthToBat() public {
    // Check BAT balance before swap
    IERC20 bat = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
    uint256 batBalanceBefore = bat.balanceOf(address(this));
    
    // Swap ETH to BAT
    swapper.swapEthToBat{value: amount}();
    
    // Check BAT balance after swap
    uint256 batBalanceAfter = bat.balanceOf(address(this));
    // Assert.notEqual(batBalanceBefore, batBalanceAfter, "BAT balance should have increased after swap");
}

function testSwapBatToEth() public {
    // Approve BAT for SwapperFacet contract
    IERC20 bat = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
    bat.approve(address(swapper), amount);
    
    // Check ETH balance before swap
    uint256 ethBalanceBefore = address(this).balance;
    
    // Swap BAT to ETH
    swapper.swapBatToEth(amount);
    
    // Check ETH balance after swap
    // uint

   

}
}