contract OverflowUnderflow {
    uint8 public smallNumber;

    function decrement() public {
        smallNumber--; // Potential underflow if smallNumber is 0
    }

    function increment() public {
        smallNumber++; // Potential overflow if smallNumber is 255
    }
}