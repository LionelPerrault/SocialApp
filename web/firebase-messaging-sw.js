importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;

firebase.initializeApp({
    apiKey: 'AIzaSyBx_Q9urZ3llnD-hkv74g1XAQWKX9uJmn4',
    appId: '1:444281700591:web:ccfe53aa54bf21fd379b1a',
    messagingSenderId: '444281700591',
    projectId: 'shnatter-a69cd',
    authDomain: 'shnatter-a69cd.firebaseapp.com',
    databaseURL: 'https://shnatter-a69cd-default-rtdb.firebaseio.com',
    storageBucket: 'shnatter-a69cd.appspot.com',
    measurementId: 'G-XGX27JVMQK',
});
    
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});