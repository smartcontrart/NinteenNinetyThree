// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import 'forge-std/Script.sol';
import '../src/NinteenNinetyThree.sol';

contract NinteenNinetyThreeScript is Script {
    function setUp() public {}
    NinteenNinetyThree public nsinteenNinetyThree;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint('PRIVATE_KEY');
        vm.startBroadcast(deployerPrivateKey);


        vm.stopBroadcast();
    }
}
