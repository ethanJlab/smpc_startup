pragma solidity ^0.8.21;

contract proxy {

    // an event for teh SMPC network to listen to
    event ProxyEvent(string indexed _data, address indexed _to, uint256 _toChainID);

    // function to send data to the SMPC network
    function sendToSMPC(address _to, string calldata _data, uint256 _toChainID) external payable public returns (bool success) {
        emit ProxyEvent(_data, _to, _toChainID);
        return true;
    } 

    fallback() external payable {
    }

    receive() external payable {
    }
}