// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin-contracts/interfaces/IERC2981.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "operator-filter-registry/DefaultOperatorFilterer.sol";

contract NinteenNinetyThreeMint{

    address ninteenNinetyThreeAddress;
    mapping(address => bool) private isAdmin;

    error Unauthorized();

    constructor(){
        isAdmin[msg.sender] = true;
    }

    modifier adminRequired() {
        if (!isAdmin[msg.sender]) revert Unauthorized();
        _;
    }

    function setNinteenNinetyThreeAddress(address _ninteenNinetyThreeAddress) external adminRequired{
        ninteenNinetyThreeAddress = _ninteenNinetyThreeAddress;
    }

}
