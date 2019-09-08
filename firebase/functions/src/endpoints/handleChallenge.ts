// import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import {GameData} from '../models/GameData'
import {Request, Response} from 'express';
import {createGame, changeGamePlayersState} from '../helpers'

export const handleChallenge = async(request:  Request, response: Response) => {

    let senderId = request.query.senderId;
    let senderName = request.query.senderName;
    let senderFcmToken = request.query.senderFcmToken;
    let receiverFcmToken = request.query.receiverFcmToken;
    let receiverId = request.query.receiverId;
    let receiverName = request.query.receiverName;
    let handleType = request.query.handleType;

    if (handleType === 'challenge') {
       
        let message = {
            data: {
                senderId: senderId,
                senderName: senderName,
                senderFcmToken: senderFcmToken,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                notificationType: 'challenge',
            },

            notification: {
                title: 'Tic Tac Toe Challenge',
                body: 'You just got a challenge from ' + senderName
            },

            token: receiverFcmToken
        };

        try{
            await admin.messaging().send(message);
            console.log('Successfully sent message:');
            return response.send(true);
        }catch(error){
            console.log('Error sending message:', error);
            return response.send(false);
        }

    } else if (handleType === 'accept') {

        let gameId = receiverId + '_' + senderId;
        // Check if the game already exists, if the last game was won by someone, start a new one instead.
        // It shows that the game was completeda already

        let notificationMessage;
       try{
        let docSnapshot = await admin.firestore().collection('games').doc(gameId).get();
        
        if(!docSnapshot.exists || (docSnapshot.exists && (docSnapshot.data() as GameData).winner !== '')){
            await createGame(gameId, receiverId, receiverName, receiverFcmToken, senderId, senderName, senderFcmToken);
            notificationMessage = 'Your game has been started!!!';
        }else{
            notificationMessage = 'Your game is being continued!!!';
        }
        console.log(notificationMessage);

        await changeGamePlayersState(senderId, receiverId, 'playing');

        let message = {
            data: {
                player1Id: receiverId, // The player that sent the challenge is player1
                player2Id: senderId,
                player1Name: receiverName,
                player2Name: senderName,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                notificationType: 'started',
            },

            notification: {
                title: 'Game Started',
                body: notificationMessage
            }
        };
        await admin.messaging().sendToDevice([senderFcmToken, receiverFcmToken], message);
        return response.send(true);

       }catch(err){
            console.log('Error subscribing to topic:', err);
            return response.send(false);
       }

    } else if (handleType === 'reject') {
        let message = {
            data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                notificationType: 'rejected',
            },
            notification: {
                title: 'Challenge Rejected!!',
                body: senderName + ' rejected your challenge.'
            },
            token: receiverFcmToken
        };

        try{
           await admin.messaging().send(message);
           return response.send(true);
        }catch(err){
            return response.send(false);
        }
    }else{
        return response.send(false);
    }

}
