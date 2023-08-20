// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface INodeRewards {
    function setURI(string memory newuri) external;
    function pause() external;
    function unpause() external;
    function mint(address account, uint256 id, uint256 amount, bytes memory data) external;
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) external;
    function burn(address account, uint256 id, uint256 amount)

}

contract Staking {
    address public owner;
    INodeRewards public nodeRewardsContract;
    uint256 public minStakingAmount = 10;

    // list of public addresses that are staking
    address[] public stakingAddresses;

    // map of addreses to bool that indicates if the address is banned
    mapping(address => bool) public bannedAddresses;

    // map of addresses to uint256 that indicates the amount of tokens staked
    mapping(address => uint256) public stakedAmounts;


    private totalStakedAmount = 0;


    constructor(address _NodeRewardsContract) {
        owner = msg.sender;
        nodeRewardsContract = INodeRewards(_NodeRewardsContract);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    // event to announce a new address has stated staking
    event newStakingAddress(address _address);

    function stake(uint256 amount, uint256 stakingId) external payable {
        // Implement logic to perform the staking here
        require(amount >= minStakingAmount, "Amount is less than the minimum staking amount");

        // check if the address is banned
        require(!bannedAddresses[msg.sender], "Address is banned");

        // accept amount of tokens from the sender and add the address to the list of staking addresses
        stakingAddresses.push(msg.sender);

        // update the amount they are staking
        stakedAmounts[msg.sender] += amount;

        // update the total staked amount
        totalStakedAmount += amount;

        // Additional logic for updating staking state, emitting events, etc
        emit newStakingAddress(msg.sender);
    }

    function unstake(uint256 amount, uint256 stakingId) external onlyOwner {
        // Implement logic to perform the unstaking here

        // Burn staking tokens from the sender's address
        nodeRewardsContract.burn(msg.sender, stakingId, amount);

        // Additional logic for updating staking state, emitting events, etc.
    }

    function banAddress(address _address) external onlyOwner {
        // Implement logic to ban an address from staking here
        bannedAddresses[_address] = true;
    }

    function unbanAddress(address _address) external onlyOwner {
        // Implement logic to unban an address from staking here
        bannedAddresses[_address] = false;
    }

    function chooseNode() external onlyOwner {
        require(stakingAddresses.length > 0, "No staking addresses available");

        uint256 totalStakedAmount = 0;

        require(totalStakedAmount > 0, "No tokens staked");

        // Generate a random number based on block data
        uint256 randomValue = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));

        // Initialize variables to track the selected address
        address selectedAddress = address(0);
        uint256 selectedValue = 0;

        // Iterate through staking addresses and select a random address based on staked amount
        for (uint256 i = 0; i < stakingAddresses.length; i++) {
            address currentAddress = stakingAddresses[i];
            uint256 currentStakedAmount = stakedAmounts[currentAddress];

            // Calculate the probability based on the staked amount
            uint256 probability = (currentStakedAmount * (randomValue + i)) / totalStakedAmount;

            if (probability > selectedValue) {
                selectedValue = probability;
                selectedAddress = currentAddress;
            }
        }

        require(selectedAddress != address(0), "No address selected");

        // Perform the action you want with the selected staking address
        // For example, emit an event, send rewards, etc.
    }

    // Add more functions as needed for your staking mechanism
}
