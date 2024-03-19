// Using off-chain data and hashes for validation
contract SecureData {
    bytes32 private hashedSecret;

    constructor(string memory _secret) {
        hashedSecret = keccak256(abi.encodePacked(_secret));
    }

    function guessSecret(string memory _guess) public view returns(bool) {
        return (keccak256(abi.encodePacked(_guess)) == hashedSecret);
    }
}