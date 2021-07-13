pragma solidity 0.4.25;

import "./ZB/ZBGameMode.sol";

contract ExampleGame is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {
        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        changes.changePlayerDefense(Player.Player1, 15);
        changes.changePlayerDefense(Player.Player2, 15);
    } //end function beforeMatchStart()

} //end contract ExampleGame{}