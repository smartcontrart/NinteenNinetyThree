// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import "forge-std/Test.sol";
import "../src/NinteenNinetyThreeRnd.sol";

contract NinteenNinetyThreeRndTest is Test {
    NinteenNinetyThreeRnd public ninteenNinetyThreeRnd;

    address payable owner;
    address collector1 = vm.addr(1);
    address collector2 = vm.addr(2);

    uint8[] counts = [2,2,2,2,2,2,1];
    uint8 public constant arrayDim = 7;

    function setUp() public {
        ninteenNinetyThreeRnd = new NinteenNinetyThreeRnd();
        owner = payable(msg.sender);
    }

    function testInitializeValues() public{
        ninteenNinetyThreeRnd.initializeValues(counts.length, counts);
    }

    function testDrawNumbers() public{
        uint256[13] memory results;
        ninteenNinetyThreeRnd.initializeValues(counts.length, counts);
        for(uint8 i = 0; i < 13; i++){
            results[i] = ninteenNinetyThreeRnd.drawNumber();
        }
    }
}
