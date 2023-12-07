importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-check-compat.js");

const firebaseConfig = {
    apiKey: "AIzaSyDtEkxCMZb7mPqZYwidJBrm7YHyRrs4-oY",
    authDomain: "spacemoonfire.firebaseapp.com",
    projectId: "spacemoonfire",
    storageBucket: "spacemoonfire.appspot.com",
    messagingSenderId: "511540428296",
    appId: "1:511540428296:web:9423fd02561f274cbcdbbd",
    measurementId: "G-8YMGS5MK94"
};

let app = firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.onBackgroundMessage((m) => {
    console.log("onBackgroundMessage", m);
});

const analytics = firebase.getAnalytics(app);

const appCheck = initializeAppCheck(app, {
    provider: new ReCaptchaV3Provider('6LdFDOQoAAAAAK3MXEtCTWtlHuiVrH3r2c_rOafy'),
    isTokenAutoRefreshEnabled: true // Set to true to allow auto-refresh.
});