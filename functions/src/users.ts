import { AuthBlockingEvent, beforeUserCreated } from "firebase-functions/v2/identity";
import { User } from "./gen/user";

export const onUserCreate = beforeUserCreated((event: AuthBlockingEvent) => {
    const { uid, email, displayName, phoneNumber, photoURL } = event.data;

    console.log(uid)

    console.log(User.create({ id: uid, email: email, nam: displayName, phone: phoneNumber, avatar: photoURL, }));
});
