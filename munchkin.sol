pragma solidity 0.4.25;

import "./ZB/ZBGameMode.sol";

contract Munchkin is ZBGameMode  {
    mapping (string => bool) internal bannedCards;

    function beforeMatchStart(bytes serializedGameState) external {
        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        changes.emit();
    } //end function beforeMatchStart()

} //end contract Munchkin{}