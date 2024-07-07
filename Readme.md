# Zero-Knowledge NFT Ownership Proof System

This project demonstrates a system that allows NFT owners to prove ownership of an NFT with a value within a specified range without revealing the token ID.The system leverages zero-knowledge proofs to maintain privacy while ensuring verifiability, making it particularly suited for Real World Assets (RWA) like real estate.

# Zero-Knowledge Proof Generation
The Real Estate NFT owner generates a zero-knowledge proof off-chain using Noir, proving that the NFT value is within the specified bounds (lower and upper).

## Overview
1. **Extended Proofs: Extend the zero-knowledge proofs to include other attributes of the real estate assets, such as location, size, and ownership history**
2. **Decentralized Valuation: Incorporate decentralized oracles to provide real-time valuations of real estate assets, further enhancing the system's reliability and accuracy.**
3. **Integration with Real Estate Platforms: Integrate this system with real estate platforms to facilitate the secure and private trading of real estate NFTs.**
4. **Privacy: The zero-knowledge proof system allows NFT owners to prove the value of their assets within a specified range without revealing the token ID or any other sensitive information.**
5. **Security: Ensures that only the legitimate owner of the NFT can prove ownership and the associated value.**






### NFT Owner and Value Setup

The contract owner sets the value and owner of each NFT using `setNFTValue` and `setNFTOwner` functions.

```solidity
// Set the value of the NFT by token ID
function setNFTValue(uint256 tokenId, uint256 value) public onlyOwner {
    nftValues[tokenId] = value;
}

// Set the owner of the NFT by token ID
function setNFTOwner(uint256 tokenId, address nftOwner) public onlyOwner {
    nftOwners[tokenId] = nftOwner;
}

//To Prove ownership of the NFT, it verifies according to our parameters
function proveOwnership(
    uint256 tokenId,
    uint256 value,
    uint256 lowerBound,
    uint256 upperBound,
    bytes calldata proof,
    bytes32[] calldata publicInputs
) public {
    require(nftOwners[tokenId] == msg.sender, "Not the owner");
    require(nftValues[tokenId] == value, "Invalid value");

    bool isValid = zkVerifier.verify(proof, publicInputs);
    require(isValid, "Invalid proof");

    emit OwnershipProven(msg.sender, tokenId, value, lowerBound, upperBound);
}


```

## Resource 
[Using Noir language for zk-proofs](https://dev.to/turupawn/zk-speedrun-3-dsls-in-15-minutes-noir-circom-zokrates-g3d)
