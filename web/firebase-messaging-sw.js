importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
 apiKey: "AIzaSyDb7jAQ2HvyGXfimczafSEWHVV4h_-j1a0",
   authDomain: "abra-9d0dd.firebaseapp.com",
   databaseURL: "https://abra-9d0dd-default-rtdb.firebaseio.com",
   projectId: "abra-9d0dd",
   storageBucket: "abra-9d0dd.appspot.com",
   messagingSenderId: "623884876607",
   appId: "1:623884876607:web:82272c80c10f776236318a",
   databaseURL: "https://abra-9d0dd-default-rtdb.firebaseio.com/",
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
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});