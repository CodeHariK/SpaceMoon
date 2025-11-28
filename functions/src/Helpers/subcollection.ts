import * as admin from "firebase-admin";

// Function to delete a Firestore collection and its documents in batches
export async function deleteCollection(collectionPath: string, batchSize: number) {
    const collectionRef = admin.firestore().collection(collectionPath);
    const query = collectionRef.limit(batchSize);

    return deleteQueryBatch(query, batchSize);
}

// Helper function to delete documents in batches
async function deleteQueryBatch(query: admin.firestore.Query<admin.firestore.DocumentData>, batchSize: number) {
    const snapshot = await query.get();

    if (snapshot.size === 0) {
        return 0;
    }

    const batch = admin.firestore().batch();
    snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
    });

    await batch.commit();

    return snapshot.size;
}
