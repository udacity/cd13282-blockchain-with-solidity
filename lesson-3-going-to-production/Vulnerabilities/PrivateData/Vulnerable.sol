contract PrivateData {
    uint private secretNumber;

    constructor(uint _secretNumber) {
        secretNumber = _secretNumber;
    }

    function guessNumber(uint _guess) public view returns(bool) {
        return (_guess == secretNumber);
    }
}