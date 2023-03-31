// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin-contracts/interfaces/IERC2981.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "./NinteenNinetyThreeRnd.sol";
import "operator-filter-registry/DefaultOperatorFilterer.sol";

contract NinteenNinetyThree is ERC1155, IERC2981, DefaultOperatorFilterer  {

    uint256 royaltyAmount;
    uint8 puzzleId;
    address royaltiesRecipient;
    address public ninteenNinetyThreeRndAddress;
    mapping(address => bool) private isAdmin;
    mapping(uint256 => string) private uris;
    mapping(uint8 => Puzzle) public puzzles;

    uint8[] public supplyLimits;

    struct Puzzle{
        uint8 id;
        uint8 numOfpieces;
        uint256 [] pieces;
        uint256 [] amounts;
        uint256 reward;
        uint256 rewardAmount;
    }

    error BalanceTooLow();  
    error InvalidPieces();
    error PuzzlePieceMissing(uint256);
    error Unauthorized();

    constructor() ERC1155(""){
        isAdmin[msg.sender] = true;
        puzzleId = 1;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, IERC165)
        returns (bool)
    {
        return
        ERC1155.supportsInterface(interfaceId) ||
        interfaceId == type(IERC2981).interfaceId ||
        super.supportsInterface(interfaceId);
    }

    modifier adminRequired() {
        if (!isAdmin[msg.sender]) revert Unauthorized();
        _;
    }

    function toggleAdmin(address _admin) external adminRequired {
        isAdmin[_admin] = !isAdmin[_admin];
    }

    function setRndAddress(address _ninteenNinetyThreeRndAddress) external adminRequired {
        ninteenNinetyThreeRndAddress = _ninteenNinetyThreeRndAddress;
    }

    function setSupplyLimits(uint8[] calldata _supplyLimits) external adminRequired {
        delete supplyLimits;
        supplyLimits = _supplyLimits;
    }

    function adminMint(address _to, uint256 _tokenId, uint256 _amount) external adminRequired {
        _mint(_to, _tokenId, _amount, "0x0");
    }

    function adminMintBatch(address _to, uint256 [] calldata _tokenIds, uint256 [] calldata _amounts) external adminRequired {
        _mintBatch(_to, _tokenIds, _amounts, "0x0");
    }

    function mint(address _to, uint256 _amount) external adminRequired {
        uint256 _tokenId = NinteenNinetyThreeRnd(ninteenNinetyThreeRndAddress).drawNumber();
        _mint(_to, _tokenId, 1, "0x0");
    }

    function mintBatch(address _to, uint256 quantity) external adminRequired {
        uint256 [] memory _tokenIds = NinteenNinetyThreeRnd(ninteenNinetyThreeRndAddress).drawMultipleNumbers(quantity);
        uint256[] memory _amounts = new uint256[](quantity);
        for(uint8 i = 0; i < quantity; i++){
            _amounts[i] = 1;
        }
        _mintBatch(_to, _tokenIds, _amounts, "0x0");
    }

    function burn(uint256 _tokenId, uint256 _amount) external {
        if(balanceOf(msg.sender, _tokenId) < _amount) revert BalanceTooLow();
        _burn(msg.sender, _tokenId, _amount);
    }

    function burnBatch(uint256 [] calldata _tokenIds, uint256 [] calldata _amounts) external {
        _burnBatch(msg.sender, _tokenIds, _amounts);
    }

    function setURI(string calldata _uri) external adminRequired {
        _setURI(_uri);
    }

    function initializeRndContract()external adminRequired{
        NinteenNinetyThreeRnd(ninteenNinetyThreeRndAddress).initializeValues(supplyLimits.length, supplyLimits);
    }

    function uri(uint256 _tokenId) public view virtual override returns (string memory) {
        return string.concat(
            uris[_tokenId],
            '/',
            Strings.toString(_tokenId),
            '.jpg'
        );
    }

    function setPuzzle(
        uint8 _numOfpieces,
        uint256 [] calldata _pieces,
        uint256 [] calldata _amounts,
        uint256 _reward,
        uint256 _rewardAmount
    ) external adminRequired{
        // if(_pieces.length != _amounts.length) revert InvalidPieces();
        Puzzle memory puzzle;
        puzzle.id = puzzleId;
        puzzle.numOfpieces = _numOfpieces;
        puzzle.pieces = _pieces;
        puzzle.amounts = _amounts;
        puzzle.reward = _reward;
        puzzle.rewardAmount = _rewardAmount;
        puzzles[puzzleId] = puzzle;
        puzzleId ++;
    }

    function solvePuzzle(uint8 _puzzleId) external {
        Puzzle memory puzzle = puzzles[_puzzleId];
        for(uint8 i = 0; i < puzzle.numOfpieces; i++){
            if(balanceOf(msg.sender, puzzle.pieces[i]) < 1) revert PuzzlePieceMissing(puzzle.pieces[i]);
        }
        _burnBatch(msg.sender, puzzle.pieces, puzzle.amounts);
        _mint(msg.sender, puzzle.reward, puzzle.rewardAmount, '0x0');
    }

    // Royalties functions
    function setRoyalties(address payable _recipient, uint256 _royaltyPerCent) external adminRequired {
        royaltiesRecipient = _recipient;
        royaltyAmount = _royaltyPerCent;
    }

    function royaltyInfo(uint256 _tokenId, uint256 salePrice) external view returns (address, uint256) {
        if(royaltiesRecipient != address(0)){
            return (royaltiesRecipient, (salePrice * royaltyAmount) / 100 );
        }
        return (address(0), 0);
    }

    // Opensea's royalty management functions
       function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
        public
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override onlyAllowedOperator(from) {
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }

}
    