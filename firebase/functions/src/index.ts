import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';
import * as bodyParser from "body-parser";

import {replayGame} from './endpoints/replayGame';
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
    res.json( { msg: "Hello from Firebase!", "body": req.query});
})

app.get('/replayGame', replayGame) 



export const addNumbers = functions.https.onRequest((request, response) => {
    response.send(Number(request.query.a) + Number(request.query.b));
  });

/*
 export const helloWorld = functions.https.onRequest((request, response) => {
     request.rawBody
  response.send("Hello from Firebase!");
 });

*/
// View a contact
/*app.get('/test/:contactId', (req: express.Request, res: express.Response) => {
    

     //   res.status(200)
     //   res.send({test:  req.params.contactId})
     return;
        
})

*/


// webApi is your functions name, and you will pass main as 
// a parameter
export const webApi = functions.https.onRequest(main);