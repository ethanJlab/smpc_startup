pragma solidity ^0.8.21;

interface proxy {
    function sendToSMPC(address _to, string calldata _data, uint256 _toChainID) payable external returns (bool success);
}

contract sender {
    // the address of teh proxy contract, initialized in a constructor
    address proxyAddress;

    // constructor to set the proxy address
    constructor(address _proxyAddress) {
        proxyAddress = _proxyAddress;
    }

    event newMessage(string _message);

    // function to send data to the SMPC network
    function sendMessage(string calldata _message, uint256 _toChainID, address _reciever_address) external payable returns (bool success) {
        // send the message to the proxy contract
        proxy(proxyAddress).sendToSMPC{value: msg.value}(_reciever_address, _message, _toChainID);
        emit newMessage(_message);
        return true;
    }
    
    fallback() externale payable {
    }
}