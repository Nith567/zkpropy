// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {UltraVerifier} from "./plonk_vk.sol"; // Import the generated zero-knowledge proof verifier

contract ZkNFT {
    mapping(uint256 => uint256) public nftValues; // Mapping to store NFT values by token ID
    mapping(uint256 => address) public nftOwners; // Mapping to store NFT owners by token ID
    UltraVerifier public zkVerifier; // Zero-knowledge proof verifier instance
    address public owner; // Owner of the contract

    constructor() {
        zkVerifier = new UltraVerifier(); // Initialize the zero-knowledge proof verifier
    }

    function setNFTValue(uint256 tokenId, uint256 value) public {
        require(nftOwners[tokenId] == msg.sender, "Not the owner"); // Ensure the sender is the owner of the NFT
        nftValues[tokenId] = value; // Set the value of the NFT by token ID
    }

    function setNFTOwner(uint256 tokenId, address nftOwner) public {
        require(nftOwners[tokenId] == address(0) || nftOwners[tokenId] == msg.sender, "Not allowed"); // Ensure only the current owner or initial setter can set the owner
        nftOwners[tokenId] = nftOwner; // Set the owner of the NFT by token ID
    }

    function proveOwnership(
        uint256 tokenId,
        uint256 value,
        uint256 lowerBound,
        uint256 upperBound,
        bytes calldata proof,
        bytes32[] calldata publicInputs
    ) public {
        require(nftValues[tokenId] == value, "Invalid value"); // Ensure the provided value matches the stored value

        bool isValid = zkVerifier.verify(proof, publicInputs); // Verify the zero-knowledge proof
        require(isValid, "Invalid proof"); // Ensure the proof is valid

        // Emit an event or handle proof validation success
        emit OwnershipProven(msg.sender, tokenId, value, lowerBound, upperBound); // Emit an event indicating successful proof of ownership
    }

    event OwnershipProven(
        address indexed owner,
        uint256 indexed tokenId,
        uint256 value,
        uint256 lowerBound,
        uint256 upperBound
    ); // Event to indicate ownership proof
}
