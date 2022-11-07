const functions = require("firebase-functions");
const admin = require('firebase-admin');
const {getAuth,linkWithCredential, EmailAuthProvider} = require('firebase/auth')
admin.initializeApp();

exports.emailVerification = functions.https.onRequest(async (req, res) => {
    res.redirect('https://shnatter-a69cd.web.app/');
  })