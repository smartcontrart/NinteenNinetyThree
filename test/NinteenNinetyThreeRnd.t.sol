// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import "forge-std/Test.sol";
import "../src/NinteenNinetyThreeRnd.sol";
import "forge-std/console.sol";

contract NinteenNinetyThreeRndTest is Test {
    NinteenNinetyThreeRnd public ninteenNinetyThreeRnd;

    address payable owner;
    address collector1 = vm.addr(1);
    address collector2 = vm.addr(2);

    uint8[] counts = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];
    uint8 public constant arrayDim =100;
    mapping (uint256 => uint256) public drawnResults;

    function setUp() public {
        ninteenNinetyThreeRnd = new NinteenNinetyThreeRnd();
        owner = payable(msg.sender);
    }

    function totalDraws() internal returns(uint256 result){
        for(uint8 i=0; i<counts.length; i++){
            result += counts[i];
        }
    }

    function testInitializeValues() public{
        ninteenNinetyThreeRnd.initializeValues(counts.length, counts);
    }

    function testDrawNumbers() public{
        uint256 totalDraws = totalDraws();
        uint256[] memory results = new uint256[](totalDraws);
        ninteenNinetyThreeRnd.initializeValues(counts.length, counts);
        for(uint256 i = 0; i < totalDraws; i++){
            results[i] = ninteenNinetyThreeRnd.drawNumber();
            drawnResults[results[i]] ++;
        }

        for(uint8 i = 0; i < arrayDim +1; i++){
            assertEq(drawnResults[i], i);
        }
    }

    function testDrawMultipleNumbers() public{
        uint256 totalDraws = totalDraws();
        uint256[] memory results = new uint256[](totalDraws);
        ninteenNinetyThreeRnd.initializeValues(counts.length, counts);
        results = ninteenNinetyThreeRnd.drawMultipleNumbers(totalDraws);
        // assertEq(results.length, totalDraws);
    }
}
