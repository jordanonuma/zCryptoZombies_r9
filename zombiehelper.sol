pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    } //end modifier aboveLevel()

    function _changeName (uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        zombies[_zombieId].name = _newName;
    } //end function _changeName()

} //end contract ZombieHelper{}