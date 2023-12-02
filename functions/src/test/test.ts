import * as assert from 'assert';
import {
    assertFails,
    assertSucceeds,
    initializeTestEnvironment,
    RulesTestContext,
    RulesTestEnvironment,
} from "@firebase/rules-unit-testing"

import { setDoc, getDoc, doc } from "firebase/firestore";

import * as fs from 'node:fs';

// import {
//     // getStorage, 
//     ref, deleteObject
// } from "firebase/storage";

import { describe, it } from "mocha";

//
//
// http://localhost:8080/emulator/v1/projects/spacemoonfire:ruleCoverage.html
//
//

const PROJECT_ID = 'spacemoonfire';
let spaceUserId = 'space';

let fire: RulesTestEnvironment;
let spaceAuth: RulesTestContext;
let unAuth: RulesTestContext;

const getFirebase = async () => {
    return await initializeTestEnvironment({
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
}

const getFirestore = (context: RulesTestContext) => {
    return context.firestore();
}

describe('Users', () => {
    beforeEach(async () => {
        fire = await getFirebase();
        unAuth = fire.unauthenticatedContext();
        spaceAuth = fire.authenticatedContext('spaceUserId', {});
    });

    it('Unauthenticated user should not see user', async () => {
        const firestore = getFirestore(unAuth);
        const f = await assertFails(getDoc(doc(firestore, 'users/hello')))
        // if (f.code != 'permission-denied') {
        //     console.log(f.FirebaseError);
        // }
        // assert.equal(f.code, 'permission-denied')
    })

    it('Authenticated user should see user', async () => {

        const firestore = getFirestore(spaceAuth);

        // assertSucceeds(getDoc(doc(firestore, 'users/hello')))
        const f = await assertSucceeds(getDoc(doc(firestore, 'users/hello')))
        console.log(f);
        // if (f != 'permission-denied') {
        // }
        // assert.equal(f, null)
        // assertSucceeds(setDoc(firestore.doc(`/users/hello`), {}))
        // assertFails(setDoc(firestore.doc(`/users/hello`), {}))
    })
});

// describe('Spacemoon', async function () {


//     describe('#indexOf()', function () {
//         it('should return -1 when the value is not present', function () {
//             assert.equal([1, 2, 3].indexOf(4), -1);
//         });
//     });


//     try {

//         let testEnv = await initializeTestEnvironment({
//             projectId: PROJECT_ID,
//             hub: {
//                 "host": "localhost",
//                 "port": 4400,
//             },
//             firestore: {
//                 rules: fs.readFileSync("../firestore.rules", "utf8"),
//                 "host": "localhost",
//                 "port": 8080,
//             },

//             storage: {
//                 rules: fs.readFileSync("../storage.rules", "utf8"),
//                 "host": "localhost",
//                 "port": 9199,
//             }
//         });



//         const spaceAuth = testEnv.authenticatedContext(spaceUserId, {});
//         const unAuth = testEnv.unauthenticatedContext();

//         describe('spaceAuth', function () {
//             it('Set doc spaceAuth', async function () {
//                 await assertSucceeds(setDoc(spaceAuth.firestore().doc(`/users/${spaceUserId}`), {}));
//                 assert.equal([1, 2, 3].indexOf(4), -1);
//             });
//         });

//         it('Set doc unauth', async function () {
//             await assertFails(setDoc(unAuth.firestore().doc(`/users/${spaceUserId}`), {}));
//         });

//         // // Use the Cloud Storage instance associated with this context
//         // const desertRef = ref(unAuth.storage(), 'images/desert.jpg');
//         // await assertFails(deleteObject(desertRef));

//     } catch (error) {
//         console.log(error);
//     }


// });


describe('Array', function () {
    describe('#indexOf()', function () {
        it('should return -1 when the value is not present', function () {
            assert.equal([1, 2, 3].indexOf(4), -1);
        });
    });
});

