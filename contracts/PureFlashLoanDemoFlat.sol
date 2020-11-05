// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

interface IPureFlash { 
     function OnFlashLoan(address token,uint256 amount, uint256 rAmount,bytes calldata userdata) external;
}
interface IPureVault{
    function startFlashLoan(address dealer,uint256 amount,bytes calldata userdata) external;
}
interface IVaultFactory { 
    function getVault(address token) external returns(address);
    function getVaultBalance(address token) external returns(uint256); 
}
interface IERC20 { 
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract PureFlashLoanDemoFlat is IPureFlash{ 
    //the factory address of PFL
    address m_vault_factory;
    constructor(address vaultFactory){
        m_vault_factory = vaultFactory;
    }

    function startFlashLoan(address token,uint256 amount) public{
      //this contract is the dealer who recive "OnFlashLoan" callack
      address dealer = address(this);
      //get PFL Vault address by token address
      address vaultAddr = IVaultFactory(m_vault_factory).getVault(token);
      //your custom data if need
      bytes memory userdata = new bytes(1);      
      IPureVault(vaultAddr).startFlashLoan(dealer,amount,userdata);
    }
    /**callback by PFL Valt Contract 
    token: token address
    amount: tokens PFL Valt sended to your contract
    rAmount: tokens with fee,need transfer back to PFL Vault,otherwise this transaction will revert.
    data:  developer custom data when startthis transaction
     */
    function OnFlashLoan(address token,uint256 amount, uint256 rAmount,bytes calldata userdata) override external{
        address flashloanVaultAddr = msg.sender;
        //your logic
        myFlashLoanLogic(token,amount,userdata);
        //transfer tokens and fee back
        IERC20(token).transfer(flashloanVaultAddr,rAmount);
    }

    function myFlashLoanLogic(address token,uint256 amount,bytes calldata userdata) private{
        //add you loginc here
        //add you loginc here
        //add you loginc here 
    }

}
