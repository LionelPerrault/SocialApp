const functions = require("firebase-functions");
const admin = require('firebase-admin');
const {getAuth,linkWithCredential, EmailAuthProvider} = require('firebase/auth')

var firebase = require('firebase/app')
require('firebase/auth');
// dependencies of firebase firestore
require('firebase/firestore');
require('firebase/analytics');

const firebaseConfig = {
  apiKey: "AIzaSyBx_Q9urZ3llnD-hkv74g1XAQWKX9uJmn4",
  authDomain: "shnatter-a69cd.firebaseapp.com",
  projectId: "shnatter-a69cd",
  storageBucket: "shnatter-a69cd.appspot.com",
  messagingSenderId: "444281700591",
  appId: "1:444281700591:web:ccfe53aa54bf21fd379b1a",
  measurementId: "G-XGX27JVMQK"
};
firebase.initializeApp(firebaseConfig);


exports.emailVerification = functions.https.onRequest(async (req, res) => {
    res.redirect('https://shnatter-a69cd.web.app/');
  })
exports.offlineRequest = functions.https.onRequest(async (req,res) => {
  cors(req, res, async () => {
    res.set("Access-Control-Allow-Origin", "*"); // you can also whitelist a specific domain like "http://127.0.0.1:4000"
    res.set("Access-Control-Allow-Headers", "Content-Type");
    var userName = req.body.userName
    var snapshot = await firebase.firestore().collection('onlineStatus').where('userName','==',userName).get()
    if(snapshot.docs.length == 0){
      await firebase.firestore().collection('onlineStatus').add({
        'userName':userName,
        'status':0
      })
    }
    else{
      await firebase.firestore().collection('onlineStatus').doc(snapshot.docs[0].id).update({
        'status':0
      })
    }
    res.send('ok')
  })
})