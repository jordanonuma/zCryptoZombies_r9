pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }//end struct{}

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) public ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);
    } //end function createZombie()

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    } //end function _generateRandomDna()

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    } //end function createRandomZombie()
} //end contract ZombieFactory {}