// import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import {GameData} from '../models/GameData'
import {Request, Response} from 'express';



export const replayGame = async(request:  Request, response: Response) => {

    try{
 
        let gameId = request.query.gameId;
        let playerId = request.query.playerId;
        let player1FcmToken = request.query.player1FcmToken;
        let player2FcmToken = request.query.player2FcmToken;

        let game = await admin.firestore().collection('games').doc(gameId).get();
        if (game.exists) {

           let gameData = game.data() as GameData;


            if (gameData.winner !== ''
                && (gameData.player1.user.id !== playerId || gameData.player2.user.id !== playerId)) {

                await admin.firestore().collection('games').doc(gameId).update({
                    winner: '',
                    pieces: {
                        0: '',
                        1: '',
                        2: '',
                        3: '',
                        4: '',
                        5: '',
                        6: '',
                        7: '',
                        8: ''
                    }

                });
                console.log('successfully updated the content');
                let message = {
                    data: {
                        notificationType: 'replayGame',
                    }
                    // notification: {
                    //     title: 'replay',
                    //     body: `replay current game`
                    // }

                };
               await admin.messaging().sendToDevice([player1FcmToken, player2FcmToken], message);
                console.log('sent to gameId'+ gameId);
                return response.send(true);

            } else {
                return response.status(403).send(false);
            }
        } else {
            console.log('not permitted');
            return response.status(404).send(false);
        }
        

    }catch(err){
        console.log('error during replay', err);
        return response.status(500).send(false);
    }

}
