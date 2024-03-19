// SafeMath library (for versions <0.8.0)
library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Underflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Overflow");
        return c;
    }
}

contract SafeCounter {
    using SafeMath for uint256;
    uint256 public counter;

    function decrement() public {
        counter = counter.sub(1); // Safely decrement, preventing underflow
    }

    function increment() public {
        counter = counter.add(1); // Safely increment, preventing overflow
    }
}