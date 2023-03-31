// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/NinteenNinetyThree.sol";

contract NinteenNinetyThreeTest is Test {
    NinteenNinetyThree public ninteenNinetyThree;

    address payable owner;
    address collector1 = vm.addr(1);
    address collector2 = vm.addr(2);
    mapping(uint256 => Puzzle) puzzles;

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
