// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlasmaChain {
    address public operator;
    uint256 public currentBlock;

    struct Deposit {
        address depositor;
        uint256 amount;
    }

    mapping(uint256 => Deposit) public deposits;
    mapping(uint256 => bytes32) public plasmaBlocks;

    event Deposited(address indexed from, uint256 amount, uint256 depositBlock);
    event SubmittedBlock(uint256 blockNumber, bytes32 rootHash);
    event Exited(address indexed to, uint256 amount);

    constructor() {
        operator = msg.sender;
        currentBlock = 1;
    }

    function deposit() external payable {
        require(msg.value > 0, "Zero deposit");

        deposits[currentBlock] = Deposit({
            depositor: msg.sender,
            amount: msg.value
        });

        emit Deposited(msg.sender, msg.value, currentBlock);
        currentBlock++;
    }

    function submitBlock(bytes32 _rootHash) external {
        require(msg.sender == operator, "Only operator can submit block");
        plasmaBlocks[currentBlock] = _rootHash;

        emit SubmittedBlock(currentBlock, _rootHash);
        currentBlock++;
    }

    function exit(uint256 depositBlock) external {
        Deposit memory dep = deposits[depositBlock];
        require(dep.depositor == msg.sender, "Not depositor");
        require(dep.amount > 0, "Already exited");

        uint256 amount = dep.amount;
        deposits[depositBlock].amount = 0;

        payable(msg.sender).transfer(amount);
        emit Exited(msg.sender, amount);
    }
}
