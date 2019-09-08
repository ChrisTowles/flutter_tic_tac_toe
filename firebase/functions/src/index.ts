import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';
import * as bodyParser from "body-parser";

import {replayGame} from './endpoints/replayGame';
import {cancelGame} from './endpoints/cancelGame';
import {handleChallenge} from './endpoints/handleChallenge';
import {playPiece} from './endpoints/playPiece';


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//


admin.initializeApp(functions.config().firebase);

//const db = admin.firestore();
const app : express.Application  = express();
const main = express();
//const contactsCollection = 'contacts';
main.use('/api/v1', app);
main.use(bodyParser.json());
main.use(bodyParser.urlencoded({ extended: false }));


app.get('/hello', (req: express.Request, res: express.Response) : void => {
    
    console.log(req)
    res.status(200).json( { msg: "Hello from Firebase!", "body": req.query});
})

app.get('/replayGame', replayGame) 
app.get('/cancelGame', cancelGame) 
app.get('/handleChallenge', handleChallenge) 
app.get('/playPiece', playPiece) 


exports.onUserStatusChanged = functions.database.ref('/status/{userId}').onUpdate(
  (change, context) => {
    // Get the data written to Realtime Database
    const eventStatus = change.after.val();
    const usersRef = admin.firestore().collection('/users');

    return usersRef
          .doc(context.params.userId)
          .set({
            currentState: eventStatus.state
          }, { merge: true });
  });


// webApi is your functions name, and you will pass main as 
// a parameter
export const webApi = functions.https.onRequest(main);