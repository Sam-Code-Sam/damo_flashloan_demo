// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

/**
 * @dev Interface of the use PFL flash loan
 */
interface IPureFlash {

    /**callback by PFL Valt Contract 
    token: token address
    amount: tokens PFL Valt sended to your contract
    rAmount: tokens with fee,need transfer back to PFL Vault,otherwise this transaction will revert.
    data:  developer custom data when startthis transaction
     */
     function OnFlashLoan(address token,uint256 amount, uint256 rAmount,bytes calldata userdata) external;
}

interface IPureVault{
    function startFlashLoan(address dealer,uint256 amount,bytes calldata userdata) external;
}

interface IVaultFactory { 
    function getVault(address token) external returns(address);
    function getVaultBalance(address token) external returns(uint256); 
}