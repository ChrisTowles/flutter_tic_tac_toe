// import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import {GameData} from '../models/GameData'
import {Request, Response} from 'express';
import {isTie, hasWin, updatePointTransaction} from '../helpers'

export const playPiece = async(request:  Request, response: Response) => {
    console.log('In play Piece .........');

    try{
            let gameId = request.query.gameId as string;
            let playerId = request.query.playerId as string;
            let position = request.query.position as number;
            let piece = '';

            let pieceUpdateKey = 'pieces.' + position;
            let scoreUpdateKey = '';
            let playersCurrentScore = 0;


            let game = await admin.firestore().collection('games').doc(gameId).get();
           


            
            if (game.exists && (game.data() as GameData).currentPlayer === playerId) { 
                 const gameData = game.data() as GameData;

                    console.log('The collection response', game.data());

                    //change the currentPLayer
                    let nextPlayer = '';
                    //TODO: refactor this and use gameData['player1'].gamePiece
                    if (gameData.currentPlayer === gameData.player1.user.id) {
                        nextPlayer = gameData.player2.user.id;
                        piece = gameData.player1.gamePiece;
                        scoreUpdateKey = 'player1.score';
                        playersCurrentScore = gameData.player1.score;
                    } else {
                        nextPlayer = gameData.player1.user.id;
                        piece = gameData.player2.gamePiece;
                        scoreUpdateKey = 'player2.score';
                        playersCurrentScore = gameData.player2.score;
                    }

                    let gamePiecesToTest = gameData.pieces;
                    gamePiecesToTest[position] = piece;

                    let winner = '';
                    let looser = '';

                    if (isTie(gamePiecesToTest)) {
                        winner = 'tie';
                    } else if (hasWin(gamePiecesToTest, piece)) {
                        winner = playerId;
                        looser = nextPlayer;
                    }
                    let gameUpdate =  {
                        currentPlayer: nextPlayer,
                        [pieceUpdateKey]: piece,
                        player1: {score: 0},
                        player2: undefined
                    };
                    if (winner !== '') {
                        gameUpdate.winner = winner;
                    }
                    if (winner !== '' && winner !== 'tie') {
                        // Adding a empty string before current score is a hack, find better later
                        gameUpdate[scoreUpdateKey] = '' + playersCurrentScore + 1;
                    }
                   
                    console.log('game update');
                    console.log(gameUpdate);
                    await admin.firestore().collection('games').doc(gameId).update(gameUpdate);
                    console.log(pieceUpdateKey); 
                    console.log('Successfully played piece!');
                    if (winner !== '' && winner !== 'tie') {
                        console.log(winner);
                        console.log(looser);
                        await Promise.all([
                            updatePointTransaction(winner, true),
                            updatePointTransaction(looser, false),
                        ]);
                        console.log('Score has been updated sucessfully');
                    }
                    return response.send(true);

                } else {
                    return response.send('Not your turn');
                }

        }catch(err){
            console.log('Error playing piece:', err);
            return response.send(false);
        }

}
