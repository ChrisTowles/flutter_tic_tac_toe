// import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import {GameData} from '../models/GameData'
import {Request, Response} from 'express';
import {changeUserState, changeGamePlayersState} from '../helpers'

export const cancelGame = async(request:  Request, response: Response) => {
    
    try{
        let gameId = request.query.gameId;
        let playerId = request.query.playerId;
        let player1FcmToken = request.query.player1FcmToken;
        let player2FcmToken = request.query.player2FcmToken;
    
        let game = await admin.firestore().collection('games').doc(gameId).get();
        if (game.exists) {
            let gameData = game.data() as GameData;
            let player1 = gameData.player1;
            let player2 = gameData.player2;

            if (/*gameData.winner !== '' &&*/
                (player1.user.id !== playerId || player2.user.id !== playerId)) {
                console.log(gameData);
                //return Promise.all([gameData.player1, gameData.player2, ]);
                await admin.firestore().collection('games').doc(gameId).delete();
                let message = {
                    data: {
                        notificationType: 'gameEnd',
                    },

                    notification: {
                        title: 'Game ended',
                        body: `Your game( ${player1.user.name} vs ${player2.user.name}) has been ended!!!`
                    }
                };
                await Promise.all([
                                admin.messaging().sendToDevice([player1FcmToken, player2FcmToken], message),
                                changeUserState(player1.user.id, 'available'),
                                changeUserState(player2.user.id, 'available'),
                                changeGamePlayersState(player1.user.id,player2.user.id,'available')
                            ]);
                    
                console.log('successfully cancelled');
                return response.send(true);
            } else {
                return response.status(403).send(false);
            }

        } else {
            return response.status(404).send(false);
        }
    

    }catch(err){

        console.log('error during game cancel', err);
        return response.status(500).send(false);
    }


}
