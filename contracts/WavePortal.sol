// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint256) public lastWaveAt;
    
    constructor() payable {
        console.log("starting a new contract");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {

        require(lastWaveAt[msg.sender] + 100 seconds < block.timestamp, 
        "You need to wait for 100 seconds before you can wave again!");

        lastWaveAt[msg.sender] = block.timestamp;
        totalWaves += 1;

        console.log("%s has waved", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        seed = (block.timestamp + block.difficulty + seed) % 100;

        console.log("Random # generated: %d", seed);

        if (seed <= 50) {
            console.log("%s won", msg.sender);

            uint256 giftAmount = 0.0001 ether;
            require(
            giftAmount <= address(this).balance,
            "Not enough balance in this contract!"
            );
            (bool success, ) = (msg.sender).call{value: giftAmount}("");
            require(success, "Failed to withdraw ETH from this contract.");
        }

        lastWaveAt[msg.sender] = block.timestamp;
        
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns(uint256) {
        console.log("we have %d total waves!", totalWaves);
        return totalWaves;
    }
}