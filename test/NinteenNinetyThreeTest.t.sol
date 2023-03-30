// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/NinteenNinetyThree.sol";

contract NinteenNinetyThreeTest is Test {
    NinteenNinetyThree public ninteenNinetyThree;

    address payable owner;
    address collector1 = vm.addr(1);
    address collector2 = vm.addr(2);

    function setUp() public {
        ninteenNinetyThree = new NinteenNinetyThree();
    }
}
