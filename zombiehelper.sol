pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    } //end modifier aboveLevel()

    function changeName (uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    } //end function _hangeName()

    function changeDna (uint _zombieId, uint  _newDna) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    } //end function changeDna()

    function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i =0; i< zombies.length;i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            } //end if()
        } //end for()

        return result;
    } //end function getZombiesByOwner()

} //end contract ZombieHelper{}