const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const axios = require("axios");
const cors = require("cors")({ origin: true });
const crypto = require("crypto");
const algorithm = "aes256";

admin.initializeApp();

exports.sendEmailToSeller = functions.firestore
  .document("transaction/{transactionId}")
  .onCreate(async (snapshot) => {
    admin
      .firestore()
      .collection("mail")
      .add({
        to: "smartdev924@gmail.com",
        message: {
          subject: "Shnatter",
          html: `<h2> You purchased product!</h2>
      <p>
         <b>Email: </b>${snapshot.data().buyer.email}<br>
      </p>`,
        },
      });

    admin
      .firestore()
      .collection("mail")
      .add({
        to: "smartdev924@gmail.com",
        message: {
          subject: "Shnatter",
          html: `<h2>Your product purchased by user!</h2>
      <p>
         <b>Email: </b>${snapshot.data().seller.email}<br>
      </p>`,
        },
      });
  });

exports.sendNotifications = functions.firestore
  .document("notifications/{notificationId}")
  .onCreate(async (snapshot) => {
    const senderSnapShot = await admin
      .firestore()
      .collection("user")
      .doc(`${snapshot.data().postAdminId}`)
      .get();
    if (snapshot.data().postType == "requestFriend") {
      const receiverSnapShot = await admin
        .firestore()
        .collection("user")
        .where("userName", "==", snapshot.data().receiver)
        .get();

      if (receiverSnapShot.docs.length != 0) {
        const userTokens = await admin
          .firestore()
          .collection("FCMToken")
          .where("userDocId", "==", receiverSnapShot.docs[0].id)
          .get();
        const tokens = [];
        userTokens.forEach((tokenDoc) => {
          tokens.push(tokenDoc.data().token);
        });
        if (tokens.length != 0) {
          try {
            const payload = {
              notification: {
                title: `Friend Request`,
                body: `${
                  senderSnapShot.data().userName
                } sent you friend reqesst!`,
                icon:
                  senderSnapShot.data().avatar ||
                  "/images/profile_placeholder.png",
                click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
              },
            };
            await admin.messaging().sendToDevice(tokens, payload);
          } catch (error) {
            functions.logger.log("error occurs while executing", error);
          }
        }
      }
    } else {
      const userTokens = await admin
        .firestore()
        .collection("FCMToken")
        .where("userDocId", "!=", snapshot.data().postAdminId)
        .get();
      const tokens = [];
      userTokens.forEach((tokenDoc) => {
        tokens.push(tokenDoc.data().token);
      });
      if (tokens.length != 0) {
        try {
          const payload = {
            notification: {
              title: snapshot.data().postType,
              body: `${senderSnapShot.data().userName} created new ${
                snapshot.data().postType
              }`,
              icon:
                senderSnapShot.data().avatar ||
                "/images/profile_placeholder.png",
              click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
            },
          };
          await admin.messaging().sendToDevice(tokens, payload);
        } catch (error) {
          functions.logger.log("error occurs while executing", error);
        }
      }
    }
  });

exports.sendNewMessageNotifications = functions.firestore
  .document("messages/{messageId}/content/{contentId}")
  .onCreate(async (snapshot) => {
    const senderSnapShot = await admin
      .firestore()
      .collection("user")
      .where("userName", "==", snapshot.data().sender)
      .get();
    const receiverSnapShot = await admin
      .firestore()
      .collection("user")
      .where("userName", "==", snapshot.data().receiver)
      .get();

    if (senderSnapShot.docs.length != 0 && receiverSnapShot.docs.length != 0) {
      const userTokens = await admin
        .firestore()
        .collection("FCMToken")
        .where("userDocId", "==", receiverSnapShot.docs[0].id)
        .get();
      const tokens = [];
      userTokens.forEach((tokenDoc) => {
        tokens.push(tokenDoc.data().token);
      });

      if (tokens.length != 0) {
        try {
          const payload = {
            notification: {
              title: `New Message from ${
                senderSnapShot.docs[0].data().userName
              }`,
              body:
                snapshot.data().type == "image"
                  ? `sent image`
                  : `${snapshot.data().data}`,
              icon:
                senderSnapShot.docs[0].data().avatar ||
                "/images/profile_placeholder.png",
              click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
            },
          };
          await admin.messaging().sendToDevice(tokens, payload);
        } catch (error) {
          functions.logger.log("error occurs while executing", error);
        }
      }
    }
  });

exports.emailVerification = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    res.set("Access-Control-Allow-Origin", "*"); 
    res.set("Access-Control-Allow-Headers", "Content-Type");
    const apiUrlAuth = "https://api.relysia.com/v1/auth";
    const serviceId = "8c67e277-4baa-44c9-955a-73f054618196";
    const shnToken = "90ed65c46635479f2113c6614a002a0dda8455a8-SHNA";
    const treasuryAccSnap = await admin
      .firestore()
      .collection("adminPanel")
      .doc('treasure')
      .get();
    const adminEmail = treasuryAccSnap.data().adminEmail;
    const adminPassword = treasuryAccSnap.data().adminPassword;
    const adminPaymailSnap = await admin
      .firestore()
      .collection("adminPanel")
      .doc('backPaymail')
      .get();
    const adminPaymail = adminPaymailSnap.data().address;
    const uuid = req.query.uid;
    const snapshot = await admin
      .firestore()
      .collection("user")
      .doc(`${uuid}`)
      .get();
    const payMail = snapshot.data().paymail;
    var token;
    const adminConfigSnap = await admin
      .firestore()
      .collection("adminPanel")
      .doc('config')
      .get();
    var balance = adminConfigSnap.data().priceTokenReward;
    if (balance == 0) return;
    var notes = "Thank you for creating your account in our website !";
    var bodyCode = { email: adminEmail, password: adminPassword };

    if (!snapshot.data().isEmailVerify) {
      functions.logger.log("get auth now");
      await axios({
        method: "post", 
        url: apiUrlAuth,
        data: bodyCode,
        headers: {
          "content-type": "application/json",
          serviceID: serviceId,
        },
      }).then((res) => {
        console.log("res.body: ", res["data"]["data"]["token"]);
        token = res["data"]["data"]["token"];
      });
      functions.logger.log("send token now");
      await axios({
        method: "post", 
        url: "https://api.relysia.com/v1/send",
        data: {
          dataArray: [
            {
              to: payMail,
              amount: balance,
              tokenId: shnToken,
              notes: notes,
            },
          ],
        },
        headers: {
          authToken: token,
          "content-type": "application/json",
          serviceID: serviceId,
        },
      }).then((res) => {
        // if (res["data"]["statusCode"] == 200) {
          
        //   console.log("success" + res["data"]["statusCode"]);
        // } else {
          
        //   console.log("Failed payment: ", "Failed payment");
        // }
      });
      functions.logger.log("verify true now");
      admin.firestore().collection("user").doc(`${uuid}`).set(
        {
          isEmailVerify: true,
        },
        { merge: true }
      );
    }
    return res.redirect("https://shnatter-a69cd.web.app/");
  });
});

exports.offlineRequest = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    var userName = req.body.userName;
    var snapshot = await admin
      .firestore()
      .collection("onlineStatus")
      .where("userName", "==", userName)
      .get();
    if (snapshot.docs.length == 0) {
      await admin.firestore().collection("onlineStatus").add({
        userName: userName,
        status: 0,
      });
    } else {
      await admin
        .firestore()
        .collection("onlineStatus")
        .doc(snapshot.docs[0].id)
        .update({
          status: 0,
        });
    }

    res.send("ok");
  });
});

exports.signup = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    const userId = req.body.data.userId;
    const friendId = req.body.data.friendId;
    const buf = Buffer.from(userId);
    const result = Buffer.concat([buf], 32);
    const iv = Buffer.concat([buf], 16);
    var cipher = crypto.createCipheriv(algorithm, result, iv);
    var encrypted =
      cipher.update(friendId, "utf8", "hex") + cipher.final("hex");
    await admin.firestore().collection("user").doc(userId).update({
      friendId: encrypted,
    });
    return res.send({ data: "success" });
  });
});
exports.getDecrypted = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    const userId = req.body.data.userId;
    const friendId = req.body.data.friendId;
    const buf = Buffer.from(userId);
    const result = Buffer.concat([buf], 32);
    const iv = Buffer.concat([buf], 16);
    var decipher = crypto.createDecipheriv(algorithm, result, iv);
    var decrypted =
      decipher.update(friendId, "hex", "utf8") + decipher.final("utf8");
    return res.send({ data: decrypted });
  });
});

exports.getLocationAutoList = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    const locationKey = req.body.data.locationKey;
    const apiKey = req.body.data.apiKey;
    const sessionToken = req.body.data.sessionToken;
    const url =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" +
      locationKey +
      " &types=address&language=en&key=" +
      apiKey +
      "&sessiontoken=$" +
      sessionToken;
    await axios({
      method: "get", 
      url: url,
      headers: {
        "content-type": "application/json",
      },
    }).then((res) => {
      console.log(res);
    });
  });
});
