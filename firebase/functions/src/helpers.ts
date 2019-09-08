import * as admin from 'firebase-admin';
import {Board} from './models/Board'
import {Score} from './models/Score'

export const isTie = (pieces: Board) =>  {
    for (let key of Object.keys(pieces)) {
        if (pieces[key] === '') {
            console.log('tie false');
            return false;
        }
    }
    return true;
}



export const hasWin = (pieces: Board, playerPiece :string) =>  {

    let possibleWins = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ];

    for (let i = 0; i < possibleWins.length; i++) {
        let currentPossibleWin = possibleWins[i];
        // String playerPiece = player.gamePiece.piece;
        if (pieces[currentPossibleWin[0]] === playerPiece &&
            pieces[currentPossibleWin[1]] === playerPiece &&
            pieces[currentPossibleWin[2]] === playerPiece) {
            console.log('win true');
            return true;
        }
    }
    console.log('win false');
    return false;
}

export const changeGamePlayersState =  async (player1Id:string, player2Id:string, state:string ) => {

    const usersRef = admin.firestore().collection('/users');
    await Promise.all([
            usersRef.doc(player1Id).set({currentState: state}, {merge:true}),
            usersRef.doc(player2Id).set({currentState: state}, {merge:true})
    ]);
}

export const createGame =  (gameId: string, 
    receiverId: string, 
    receiverName: string,
     receiverFcmToken: string, 
     senderId: string,
      senderName: string,
       senderFcmToken: string,) => {
    return admin.firestore().collection('games').doc(gameId).set({
        //The player who sent the challenge is always player1 and will always be X.
        player1: {
            user: {
                id: receiverId,
                name: receiverName,
                fcmToken: receiverFcmToken
            },
            gamePiece: 'X',
            score: 0
        },
        player2: {
            user: {
                id: senderId,
                name: senderName,
                fcmToken: senderFcmToken
            },
            gamePiece: 'O',
            score: 0
        },
        winner: '',
        currentPlayer: receiverId,
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
}




export const changeUserState = (userId: string, state:string) => {

    return admin.firestore().collection("users").doc(userId).set({
        currentState: state
    }, { merge: true });
}



export const updatePointTransaction =  (playerId: string, wonGame:boolean) => {

    let scoreDocRef = admin.firestore().collection("scores").doc(playerId);
    return  admin.firestore().runTransaction((transaction) => {
        // This code may get re-run multiple times if there are conflicts.
        return transaction.get(scoreDocRef).then((sfDoc) => {
            if (!sfDoc.exists) {
               return transaction.create(scoreDocRef, {
                   wins: (wonGame)? 1 : 0,
                   losses: (wonGame)? 0 : 1,
                   wonLast: (wonGame)? true : false
               });
            }  

            let updateObject = {};

            const score = sfDoc.data() as Score;
            if(wonGame){
                updateObject = {
                    wonLast:true,
                    wins: score.wins + 1 
                }
            }else{
                updateObject = {
                    wonLast:false,
                    losses:score.losses + 1 
                }
            }
           
            return transaction.update(scoreDocRef, updateObject);
        });
    });
}