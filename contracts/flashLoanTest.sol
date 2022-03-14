// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import "https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// pool addresses provider = 0x87A5b1cD19fC93dfeb177CCEc3686a48c53D65Ec
contract testflashloan is FlashLoanSimpleReceiverBase, Ownable {

    address public kovanDAI = address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD); // Kovan DAI

    constructor(IPoolAddressesProvider _provider ) FlashLoanSimpleReceiverBase(_provider) {}

    function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
  ) external override returns (bool) {

      uint amoutOwing = amount + premium;
      IERC20(asset).approve(address(POOL), amoutOwing);

    return true;
  }

  function flashLoanSimple() public {

    address receiverAddress = address(this);

    address asset = kovanDAI; // Kovan DAI
    uint256 amount = 1 ether;

    bytes memory params = "";
    uint16 referralCode = 0;


    POOL.flashLoanSimple(
        receiverAddress,
        asset,
        amount,
        params,
        referralCode
    );
    
  }

  function withdraw() public payable onlyOwner {
        
        // withdraw all ETH
        msg.sender.call{ value: address(this).balance }("");
        
        // withdraw all x ERC20 tokens
        IERC20(kovanDAI).transfer(msg.sender, IERC20(kovanDAI).balanceOf(address(this)));
    }
}