// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
import "./@interface/IERC20.sol";
import "./@interface/IPureFlash.sol";
contract PureFlashLoanDemo is IPureFlash{ 

    //PFL 项目工厂合约地址，主要用于根据token地址获取保险柜地址
    address m_vault_factory;
    constructor(address vaultFactory){
        m_vault_factory = vaultFactory;
    }

    //发起闪电贷调用接口，
    /**发起闪电贷调用接口
    * token: 要借的token 
    * amount:借入的数量
    * 备注：也可以直接调用保险柜合约并设置借贷处理合约dealer，发起借贷
    */
    function startFlashLoan(address token,uint256 amount) public{
      //dealer设为本合约， 本合约需要实现IPureFlash接口的 "OnFlashLoan" 回调方法
      address dealer = address(this);
      //根据token地址获取PFL保险柜地址
      address vaultAddr = IVaultFactory(m_vault_factory).getVault(token);
      //开发者自定义数据
      bytes memory userdata = new bytes(1);  
      //向保险柜申请贷款，并回调dealer地址所在合约的 OnFlashLoan 方法  
      IPureVault(vaultAddr).startFlashLoan(dealer,amount,userdata);
    }
    /**保险柜合约回调接口，在IPureFlash中定义
    token: 借款的token
    amount: 借款的数量
    rAmount: 借款的数量+手续费
    data:  透传的开发者自定义数据
     */
    function OnFlashLoan(address token,uint256 amount, uint256 rAmount,bytes calldata userdata) override external{
        //本函数又PFL保险柜合约发起，msg.sender即是PFL保险柜合约地址
        address flashloanVaultAddr = msg.sender;
        //开发者自己的逻辑处理
        myFlashLoanLogic(token,amount,userdata);
        //返款给PFL保险柜
        IERC20(token).transfer(flashloanVaultAddr,rAmount);
    }

    function myFlashLoanLogic(address token,uint256 amount,bytes calldata userdata) private{
        //你的闪电贷处理逻辑
    }

}
