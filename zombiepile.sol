pragma solidity 0.4.25;

import "./ZB/ZBGameMode.sol";

contract ZombiePile is ZBGameMode  {
    mapping (string => bool) internal bannedCards;

    function beforeMatchStart(bytes serializedGameState) external {
        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        CardInstance[] memory player1Cards = new CardInstance[](gameState.playerStates[0].cardsInDeck.length);
        CardInstance[] memory player2Cards = new CardInstance[](gameState.playerStates[1].cardsInDeck.length);
        uint player1CardCount = 0;
        uint player2CardCount = 0;

        for (uint i = 0; i < gameState.playerStates.length; i++) {
            
            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                uint rand = uint(keccak256(abi.encodePacked(now, player1CardCount + player2CardCount))) % 2;

                //Balances out player's decks if their dealt cards exceeds their initial amount. Not sure how this works on an odd number cards in the pile.
                if (player1CardCount +1 > gameState.playerStates[0].cardsInDeck.length) {
                    rand = 1;
                } //end if()
                else if (player2CardCount+1 > gameState.playerStates[1].cardsInDeck.length) {
                    rand = 0;
                } //end else if()

                if (rand == 0) {
                    player1Cards[player1CardCount] = gameState.playerStates[i].cardsInDeck[j];
                    player1CardCount++;
                } else {
                    player2Cards[player2CardCount] = gameState.playerStates[i].cardsInDeck[j];
                    player2CardCount++;
                } //end if-else()
            } //end for(j)

        } //end for(i)

        changes.changePlayerCardsInDeck(Player.Player1, player1Cards, player1CardCount);
        changes.changePlayerCardsInDeck(Player.Player2, player2Cards, player2CardCount);
        changes.emit();
    } //end function beforeMatchStart()

} //end contract ZombiePile{}