pragma solidity >=0.5.0 <0.6.0;
import "./zombiefactory.sol";


    
    contract KittyInterface {
        function getKitty(uint256 _id) external view returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
    } //end interface KittyInterface{}

contract ZombieFeeding is ZombieFactory {
    
    KittyInterface kittyContract;
    function setKittyContractAddress(address _address) external {
        kittyContract = KittyInterface(_address);
    } //end function setKittyContractAddress()

    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];

        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna)/2;
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna % 100 + 99;
        } //end if()
        _createZombie("NoName", newDna);
    } //end function feedAndMultiply()

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    } //end function feedOnKitty()
} //end contract ZombieFeeding{}