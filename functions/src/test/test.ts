import * as assert from 'assert';
import {
    assertFails,
    assertSucceeds,
    initializeTestEnvironment,
} from "@firebase/rules-unit-testing"

import { setDoc, getDoc, doc, where } from "firebase/firestore";

import * as fs from 'node:fs';

import * as firetypes from '@firebase/firestore-types';
import * as storetypes from '@firebase/storage-types';

import { ref, deleteObject, uploadString } from "firebase/storage";

import { describe, it } from "mocha";

//
//
// http://localhost:8080/emulator/v1/projects/spacemoonfire:ruleCoverage.html
//
//

const PROJECT_ID = 'spacemoonfire';
let space = 'space';

let spaceFirestore: firetypes.FirebaseFirestore;
let unAuthFirestore: firetypes.FirebaseFirestore;
let spaceStorage: storetypes.FirebaseStorage;
let unAuthStorage: storetypes.FirebaseStorage;

const getFirebase = async () => {
    let testEnv = await initializeTestEnvironment({
        projectId: PROJECT_ID,
        firestore: {
            rules: fs.readFileSync("../firestore.rules", "utf8"),
            "host": "localhost",
            "port": 8080,
        },

        storage: {
            rules: fs.readFileSync("../storage.rules", "utf8"),
            "host": "localhost",
            "port": 9199,
        }
    });

    return testEnv;
}

describe('Users', () => {
    beforeEach(async () => {
        let fire = await getFirebase();
        await fire.clearFirestore();
        unAuthFirestore = fire.unauthenticatedContext().firestore();
        spaceFirestore = fire.authenticatedContext(space, {}).firestore();
    });
    it('Unauthenticated user should not see user', async () => {
        await assertFails(getDoc(doc(unAuthFirestore, 'users/hello')))
    });
    it('Unauthenticated user should not set user', async () => {
        await assertFails(setDoc(unAuthFirestore.doc(`/users/hello`), {}))
    });
    it('Authenticated user should see user', async () => {
        await assertSucceeds(getDoc(doc(spaceFirestore, 'users/hello')))
    });
    it('Authenticated user should set self user', async () => {
        await assertSucceeds(setDoc(spaceFirestore.doc(`/users/${space}`), {}))
    });
    it('Authenticated user should not set other user', async () => {
        await assertFails(setDoc(spaceFirestore.doc(`/users/hello`), {}))
    });


    //------

    // // Room Rules
    // it('Authenticated user should read rooms', async () => {
    //     await assertSucceeds(getDoc(doc(spaceFirestore, 'rooms/room123')));
    // });

    // it('Authenticated user should write to rooms if admin', async () => {
    //     await assertSucceeds(setDoc(spaceFirestore.doc('/rooms/room123'), {}));
    // });

    // it('Authenticated user should not write to rooms if not admin', async () => {
    //     await assertFails(setDoc(spaceFirestore.doc('/rooms/room456'), {}));
    // });

    // // Tweet Rules
    // it('Authenticated user should read tweets in a room', async () => {
    //     await assertSucceeds(getDoc(doc(spaceFirestore, 'rooms/room123/tweets/tweet456')));
    // });

    // it('Authenticated user should write own tweet in a room', async () => {
    //     await assertSucceeds(setDoc(spaceFirestore.doc('/rooms/room123/tweets/tweet789'), { user: space }));
    // });

    // it('Authenticated user should not write another user\'s tweet in a room', async () => {
    //     await assertFails(setDoc(spaceFirestore.doc('/rooms/room123/tweets/tweet101'), { user: 'otherUser' }));
    // });

    // // Room User Rules
    // it('Authenticated user should read room users', async () => {
    //     await assertSucceeds(getDoc(doc(spaceFirestore, 'roomusers/user123_room456')));
    // });

    // it('Authenticated user should write own room user', async () => {
    //     await assertSucceeds(setDoc(spaceFirestore.doc('/roomusers/user123_room456'), { user: 'user123' }));
    // });

    // it('Authenticated user should not write another user\'s room user', async () => {
    //     await assertFails(setDoc(spaceFirestore.doc('/roomusers/user789_room456'), { user: 'user789' }));
    // });

    // // Admin-Only Rules
    // it('Admin should write to rooms', async () => {
    //     await assertSucceeds(setDoc(spaceFirestore.doc('/rooms/room123'), {}));
    // });

    // it('Non-admin should not write to rooms', async () => {
    //     await assertFails(setDoc(spaceFirestore.doc('/rooms/room456'), {}));
    // });

    // // Moderator-Only Rules
    // it('Moderator should write to rooms', async () => {
    //     await assertSucceeds(setDoc(spaceFirestore.doc('/rooms/room789'), {}));
    // });

    // it('Non-moderator should not write to rooms', async () => {
    //     await assertFails(setDoc(spaceFirestore.doc('/rooms/room101'), {}));
    // });
});

describe('Storage', () => {
    beforeEach(async () => {
        let fire = await getFirebase();
        await fire.clearStorage();
        unAuthStorage = fire.unauthenticatedContext().storage();
        spaceStorage = fire.authenticatedContext(space, {}).storage();
    });
    it('Unauthenticated user should not put', async () => {
        await assertFails(uploadString(ref(unAuthStorage, 'images/desert.jpg'), 'Hello'));
    });
    it('Unauthenticated user should not delete', async () => {
        await assertFails(deleteObject(ref(unAuthStorage, 'images/desert.jpg')));
    });
    it('Authenticated user should put', async () => {
        await assertSucceeds(uploadString(ref(spaceStorage, 'images/desert.txt'), 'Hello'));
    });
    it('Authenticated user should delete', async () => {
        await assertSucceeds(deleteObject(ref(spaceStorage, 'images/desert.txt')));
    });
});

after(
    async () => {
        let fire = await getFirebase();
        await fire.cleanup();
    }
);