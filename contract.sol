// SPDC-Licence-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.1/access/Ownable.sol";
import "@openzeppelin/contracts@4.4.1/utils.Counters.sol";
import "@openzeppelin/contracts@4.4.1/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts@4.4.1/utils/cryptography/draft-EIP712.sol";

contract MyToken is ERC721, EIP712, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private constant SIGNING_DOMAIN = "WEB3CLUB";
    string private constant SIGNATURE_VERSION = "1";
    mapping (uint256 => bool) public redeemed;

    constructor() ERC721("My Token", "MTK") EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {}

    function safeMint(address to, uint256 id, string memory message, bytes memory signature) public {
        require(check(id, message, signature) == owner(), "Voucher invalid");
        require(redeemed[id] != true, "Already redeemed");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        redeemed[id] = true;
    }

    function check(uint256 id, string memory message, bytes memory signature) public view returns (address) {
        return _verify(id, message, signature);
    }

    function _verify(uint256 id, string memory message, bytes memory signature) internal view returns (address) {
        bytes32 digest = _hash(id, message);
        return ECDSA.recover(digest, signature);
    }

    function _hash(uint256 id, string message) internal view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(
            keccak256("Web3Struct(uint256 id,string message"),
            id,
            keccak256(bytes(message))
            // keccak256(bytes(STRING)) for string
        )))
    }
}