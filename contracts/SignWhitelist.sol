// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";

contract SignWhitelist is ERC721, EIP712 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private constant SIGNING_DOMAIN = "WEB3CLUB";
    string private constant SIGNATURE_VERSION = "1";
    mapping (address => bool) public redeemed;

    constructor() ERC721("My NFT", "NFT") EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {}

    function safeMint(uint256 id, string memory message, bytes memory signature) public {
        require(check(id, message, signature) == msg.sender, "Voucher invalid");
        require(!redeemed[msg.sender], "Already redeemed");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, tokenId);
        redeemed[msg.sender] = true;
    }

    function check(uint256 id, string memory message, bytes memory signature) public view returns (address) {
        return _verify(id, message, signature);
    }

    function _verify(uint256 id, string memory message, bytes memory signature) internal view returns (address) {
        bytes32 digest = _hash(id, message);
        return ECDSA.recover(digest, signature);
    }

    function _hash(uint256 id, string memory message) internal view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(
            keccak256("Web3Struct(uint256 id,string message)"),
            id,
            keccak256(bytes(message))
            // keccak256(bytes(STRING)) for string
        )));
    }
}