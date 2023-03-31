// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/NinteenNinetyThree.sol";
import "../src/NinteenNinetyThreeRnd.sol";

contract NinteenNinetyThreeTest is Test {
    NinteenNinetyThree public ninteenNinetyThree;
    NinteenNinetyThreeRnd public ninteenNinetyThreeRnd;

    address payable owner;
    address collector1 = vm.addr(1);
    address collector2 = vm.addr(2);

    mapping(uint256 => Puzzle) puzzles;
    uint8[] supplyLimits = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    struct Puzzle{
        uint8 id;
        uint8 numOfpieces;
        uint256 [] pieces;
        uint256 [] amounts;
        uint256 reward;
        uint256 rewardAmount;
    }

    function setUp() public {
        ninteenNinetyThree = new NinteenNinetyThree();
        ninteenNinetyThreeRnd = new NinteenNinetyThreeRnd();
        owner = payable(msg.sender);
    }

    // Test of admin functions

    function testSetAdmin(address _address) public{
        ninteenNinetyThree.toggleAdmin(_address);
    }

    function testFailSetAdmin(address _address) public{
        vm.prank(collector1);
        ninteenNinetyThree.toggleAdmin(_address);
    }

    function testSetSupplyLimits() public{
        ninteenNinetyThree.setSupplyLimits(supplyLimits);
    }

    function testFailSetSupplyLimits() public{
        vm.prank(collector1);
        ninteenNinetyThree.setSupplyLimits(supplyLimits);
    }   

    function testInitializeRndContract() public{
        ninteenNinetyThree.setSupplyLimits(supplyLimits);
        ninteenNinetyThree.setRndAddress(address(ninteenNinetyThreeRnd));
        ninteenNinetyThreeRnd.toggleAdmin(address(ninteenNinetyThree));
        ninteenNinetyThree.initializeRndContract();
    }

    function testFailInitializeRndContract() public{
        ninteenNinetyThree.setSupplyLimits(supplyLimits);
        ninteenNinetyThree.setRndAddress(address(ninteenNinetyThreeRnd));
        ninteenNinetyThreeRnd.toggleAdmin(address(ninteenNinetyThree));
        vm.prank(collector1);
        ninteenNinetyThree.initializeRndContract();
    }

    function testSetUri(string calldata _uri) public{
        ninteenNinetyThree.setURI(_uri);
    }

    function testFailSetUri(string calldata _uri) public{
        vm.prank(collector1);
        ninteenNinetyThree.setURI(_uri);
    }

    function testSetPuzzle(
        uint8 _numOfpieces,
        uint256 [] calldata _pieces,
        uint256 [] calldata _amounts,
        uint256 _reward,
        uint256 _rewardAmount
    ) public {
        vm.assume(_pieces.length>100);
        ninteenNinetyThree.setPuzzle(
            _numOfpieces,
            _pieces,
            _amounts,
            _reward,
            _rewardAmount
        );
    }

    function testFailSetPuzzle(
        uint8 _numOfpieces,
        uint256 [] calldata _pieces,
        uint256 [] calldata _amounts,
        uint256 _reward,
        uint256 _rewardAmount
    ) public {
        vm.prank(collector1);

        ninteenNinetyThree.setPuzzle(
            _numOfpieces,
            _pieces,
            _amounts,
            _reward,
            _rewardAmount
        );
    }
}
