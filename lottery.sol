// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0<0.9.0;
contract Lottery{
    address public manager;
    address payable[] public participants;
    constructor(){
        manager=msg.sender;
    }
    receive() external payable {
        require(msg.value==1 ether);
        require(msg.sender!=manager,"You are manager");
        participants.push(payable (msg.sender));
    }

    address payable user;
    function transferEther(address participantsAddress) public {
        user=payable(participantsAddress);
    }
    function sendether(uint amount) public {
        user.transfer(amount);
    }
    function getbalance() public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
    } 
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }
    function selectWinner() public returns (address){
        require(msg.sender==manager);
        require(participants.length>=3);
        uint index=random()% participants.length;
        transferEther(participants[index]);
        uint refundAmount=getbalance();
        sendether(refundAmount);
        return participants[index];
    }
}
