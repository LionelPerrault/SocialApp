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
    functions.logger.log('*****************************************');
    functions.logger.log('sender');
    functions.logger.log(snapshot.data().postAdminId);
    functions.logger.log("receiver");
    functions.logger.log(snapshot.data().receiver);
    // try{
    const receiverSnapShot = await admin.firestore().collection('users').where('userName','==',snapshot.data().receiver).get()
    const senderSnapShot = await admin.firestore().collection('users').where('uid','==',snapshot.data().postAdminId).get()
    const userTokens = await admin.firestore().collection('FCMToken').where('userDocId', '==', receiverSnapShot.data().uid).get();
    functions.logger.log(senderSnapShot.data().userName);
    functions.logger.log(receiverSnapShot.data().userName);
    const tokens = [];
    userTokens.forEach((tokenDoc) => {
      tokens.push(tokenDoc.data().token);
    });
    functions.logger.log('*****************This is sender info ************************');


    //  const payload = {
    //     notification: {
    //       title: `Friend Request`,
    //       body:`${senderSnapShot.data().userName} sent you friend reqesst!`,
    //       icon: senderSnapShot.data().avatar || '/images/profile_placeholder.png',
    //       click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
    //     }
    //   }
    //   const response = await admin.messaging().sendToDevice(tokens, payload);
    //   await cleanupTokens(response, tokens);
    // } catch(error) {
    //   functions.logger.log("error occurs while executing",error);
    // }
  });
// exports.sendNotifications = functions.firestore.document('User/{userId}').onUpdate(
//   async (snapshot) =>{
//     const docId = snapshot.after.id;
//     functions.logger.log('doc id is ', snapshot.after.id);
//     functions.logger.log(snapshot);
//     try{
//       if (snapshot.before.data().count == snapshot.after.data().count || snapshot.after.data().count == 0)
//       {
//         functions.logger.log('transaction doesn\'t made');
//         return;
//       }
//       functions.logger.log('count is',snapshot.after.data().count);
//       // get datas for this doc id;
//       const userTokens = await admin.firestore().collection('FCMToken').where('userDocId', '==', docId).get();
//       const tokens = [];
//       userTokens.forEach((tokenDoc) => {
//         tokens.push(tokenDoc.data().token);
//       });
//       // const payload = {
//       //   notification: {
//       //     title: `${snapshot.data().name} posted ${text ? 'a message' : 'an image'}`,
//       //     body: text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : '',
//       //     icon: snapshot.data().profilePicUrl || '/images/profile_placeholder.png',
//       //     click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
//       //   }
//       // };
//       const payload = {
//         notification: {
//           title: `Success!`,
//           body: 'You\'ve got transactions',
//           icon: '',
//           click_action: ``,
//           badge:snapshot.after.data().count.toString()
//         }
//       };
//       if (tokens.length > 0) {
//         // Send notifications to all tokens.
//         const response = await admin.messaging().sendToDevice(tokens, payload);
//         //await cleanupTokens(response, tokens);
//         //functions.logger.log('Notifications have been sent and tokens cleaned up.');
//       }
//     }catch (error)
//     {
//       functions.logger.log("error occurs while executing",error);
//     }
//   }
// )
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