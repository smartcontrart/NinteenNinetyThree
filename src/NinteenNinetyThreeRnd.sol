// SPDX-License-Identifier: MIT
pragma solidity >=  0.8.18;

import "forge-std/console.sol";

contract NinteenNinetyThreeRnd {
    struct Number {
        uint256 value;
        uint256 count;
    }

    mapping (uint256 => Number) private numbers;
    uint256 private totalNumbers;
    uint256 private totalDraws;
    uint256 public nonce;

    constructor() {
    }

    function initializeValues(uint256 _totalNumbers, uint8 [] calldata numberCounts) external{
        totalNumbers = _totalNumbers;
        for (uint256 i = 1; i <= _totalNumbers; i++) {
            numbers[i] = Number(i, numberCounts[i - 1]);
            totalDraws += numbers[i].count;
        }
    }

    function drawNumber() public returns (uint256) {
        require(totalDraws > 0, "No numbers left to draw");

        // Generate a random index within the range of available numbers
        uint256 index = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao    , nonce))) % totalDraws;

        // Find the number corresponding to the selected index and remove it from the mapping
        uint256 drawnNumber;
        for (uint256 i = 1; i <= totalNumbers; i++) {
            Number storage number = numbers[i];
            if (number.count > 0 && index < number.count) {
                drawnNumber = number.value;
                number.count--;
                break;
            } else {
                index -= number.count;
            }
        }
        nonce ++;
        // If no number was drawn, try again
        if (drawnNumber == 0) {
            return drawNumber();
        }
        totalDraws--;
        console.log(drawnNumber);
        return drawnNumber;
    }
}
