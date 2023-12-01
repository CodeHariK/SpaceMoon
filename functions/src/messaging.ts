import * as admin from "firebase-admin";
import { onCall } from "firebase-functions/v2/https";

export const sendMessage = onCall({
    enforceAppCheck: true,
}, (request): void => {
    admin.messaging().send({
        token: "device token",
        data: {
            hello: "world",
        },
        "notification": {
            "title": "Match update",
            "body": "Arsenal goal in added time, score is now 3-0"
        },
        // Set Android priority to "high"
        android: {
            priority: "high",
        },
        // Add APNS (Apple) config
        apns: {
            payload: {
                aps: {
                    contentAvailable: true,
                },
            },
            headers: {
                "apns-push-type": "background",
                "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
                "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
            },
        },
    });
});

