const functions = require('firebase-functions');
const admin = require("firebase-admin");
const axios = require('axios');
const cors = require('cors')({origin: true});
admin.initializeApp();

exports.offlineRequest = functions.https.onRequest(async (req,res) => {
  cors(req, res, async () => {
    res.set("Access-Control-Allow-Origin", "*"); // you can also whitelist a specific domain like "http://127.0.0.1:4000"
    res.set("Access-Control-Allow-Headers", "Content-Type");
    var userName = req.body.userName
    var snapshot = await admin.firestore().collection('onlineStatus').where('userName','==',userName).get()
    if(snapshot.docs.length == 0){
      await admin.firestore().collection('onlineStatus').add({
        'userName':userName,
        'status':0
      })
    }
    else{
      await admin.firestore().collection('onlineStatus').doc(snapshot.docs[0].id).update({
        'status':0
      })
    }
    console.log('asdf', 'asdfasdfwer234235');
    res.send('ok')
  })
})

exports.sendNotifications = functions.firestore.document('notifications/{notificationId}').onCreate(
  async (snapshot) => {
    const senderSnapShot = await admin.firestore().collection('user').doc(`${snapshot.data().postAdminId}`).get();
    
    const receiverSnapShot = await admin.firestore().collection('user').where('userName','==',snapshot.data().receiver).get()
    functions.logger.log(receiverSnapShot.docs[0].id);
    if (receiverSnapShot.docs.length !=0){
      const userTokens = await admin.firestore().collection('FCMToken').where('userDocId', '==', receiverSnapShot.docs[0].id).get();
      const tokens = [];
      userTokens.forEach((tokenDoc) => {
        tokens.push(tokenDoc.data().token);
      });
      if (tokens.length != 0) {
        try{
        const payload = {
            notification: {
              title: `Friend Request`,
              body:`${senderSnapShot.data().userName} sent you friend reqesst!`,
              icon: senderSnapShot.data().avatar || '/images/profile_placeholder.png',
              click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
            }
          }
          await admin.messaging().sendToDevice(tokens, payload);        
        } catch(error) {
          functions.logger.log("error occurs while executing",error);
        }
      }
    }
  });
  
  exports.sendNewMessageNotifications = functions.firestore.document('messages/{messageId}/content/{contentId}').onCreate(
    async (snapshot) => {
      functions.logger.log("New message ****************************** notification");
      functions.logger.log(snapshot.data());
    })
  


exports.emailVerification = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    res.set("Access-Control-Allow-Origin", "*"); // you can also whitelist a specific domain like "http://127.0.0.1:4000"
    res.set("Access-Control-Allow-Headers", "Content-Type");
    const apiUrlAuth = 'https://api.relysia.com/v1/auth';
    const serviceId = '9ab1b69e-92ae-4612-9a4f-c5a102a6c068';
    const shnToken1 = '9a0e862be07d8aa56311e5b211a4fdf9ddf03b2f-BNAF';
    const shnToken = '9a0e862be07d8aa56311e5b211a4fdf9ddf03b2f-SHNATST';
    const adminEmail = 'artem@gmail.com';
    const adminPassword = 'entertainment';
    const adminPaymail = '4326@shnatter.com';
    const uuid = req.query.uid;
    const snapshot = await admin.firestore().collection('user').doc(`${uuid}`).get();
    const payMail = snapshot.data().paymail;
    var token;
    var balance = 10;
    var notes = 'Thank you for creating your account in our website !';
    var bodyCode = {'email': adminEmail, 'password': adminPassword};

    if(!snapshot.data().isEmailVerify){
      await axios({
        method: 'post', //you can set what request you want to be
        url: apiUrlAuth,
        data: bodyCode,
        headers: {
          'content-type': 'application/json',
          'serviceID': serviceId
        }
      })
      .then((res) => {
        console.log('res.body: ', res['data']['data']['token']);
        token = res['data']['data']['token'];
      });
      await axios({
        method: 'post', //you can set what request you want to be
        url: 'https://api.relysia.com/v1/send',
        data: { "dataArray" : [
          {
            'to' : payMail, 
            'amount' : balance, 
            'tokenId' : shnToken, 
            'notes': notes
          }
        ]},
        headers: {
          'authToken': token,
          'content-type': 'application/json',
          'serviceID': serviceId,
        }
      })
      .then(
        (res) => {
          if (res['data']['statusCode'] == 200){
            // returnData = 'Successfully paid',
            console.log("success" + res['data']['statusCode']);
          }else {
            // returnData = 'Failed payment';
            console.log('Failed payment: ', 'Failed payment');
          }
        },
      );
      admin.firestore().collection('user').doc(`${uuid}`).set(
        {
          isEmailVerify: true
        },
        { merge: true },
      );
    }
    return res.redirect('https://shnatter-a69cd.web.app/');
  })
})