// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol";
contract MyToken is ERC721, ERC721Enumerable, ERC2981, Ownable {
    // uint96 royaltyFeesInBips;
    // address royaltyReceiver;
    string public contractURI;
    constructor(uint96 _royaltyFeesInBips, string memory _contractURI) ERC721("MyToken", "MTK") {
        // royaltyFeesInBips = _royaltyFeesInBips;
        setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
        contractURI = _contractURI;
        // royaltyReceiver = msg.sender;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns(address receiver, uint256 royaltyAmount) {
    //     return (royaltyReceiver, calculateRoyalty(_salePrice));
    // }

    // function calculateRoyalty(uint256 _salePrice) view public returns(uint256) {
    //     return (_salePrice / 10000) * royaltyFeesInBips;
    // }

    function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
        // royaltyReceiver = _receiver;
        // royaltyFeesInBips = _royaltyFeesInBips;
        _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
    }

    function setContractURI(string calldata _contractURI) public onlyOwner {
        contractURI = _contractURI;
    }
}