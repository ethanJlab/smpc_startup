pragma solidity ^0.8.21;

contract reciever {
    event newMessage(string _message);

    function emmitMessage(string calldata _message) external payable returns (bool success) {
        emit newMessage(_message);
        return true;
    }

    fallback() external payable {
    }

    receive() external payable {
    }
}