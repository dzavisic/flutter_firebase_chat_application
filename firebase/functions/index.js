const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { relevantIndex, relevantSearch } = require('adv-firestore-functions');

admin.initializeApp();

exports.generateUser = functions.https.onCall(async (data, context) => {

  await admin.firestore().collection('users').doc(data.uid).set({
    firstName: data.firstName,
    lastName: data.lastName,
    email: data.email,
    phone: data.phone,
    photo: data.photo,
    role: data.role,
  });

  return 'Successfully added new user';
});

/**
 * Updates users custom claims when
 * the users role changes in firestore
 */
exports.userDocumentUpdated = functions
  .firestore
  .document(`users/{documentId}`)
  .onWrite(async change => {
    const after = change.after.data();
    const before = change.before.data();

    if (after && after?.email !== before?.email) {
      await admin.auth().updateUser(change.after.id, {
        email: after.email
      });
    }

    if (after?.role !== before?.role && after) {
      await admin.auth().setCustomUserClaims(
        change.after.id,
        {
          role: after.role
        }
      )
    }
  });

exports.documentWrite = functions
  .firestore
  .document('{colId}/{docId}')
  .onWrite(async (change, context) => {
    if (change.before.exists) {
      const data = change.before.data();

      change.before.data = () => {
        return {
          ...data,
          id: change.before.id
        };
      }
    }

    if (change.after.exists) {
      const data = change.after.data();

      change.after.data = () => {
        return {
          ...data,
          id: change.after.id
        };
      }
    }

    const search = {
      users: ['firstName', 'lastName', 'email', 'phone']
    }

    if (Object.keys(search).includes(context.params.colId)) {
      await relevantIndex(change, context, {
        fields: [...(search[context.params.colId] || [])]
      });
    }
  });

exports.relevantSearch = functions.https.onCall(async (data) => {

  data.query = (data.query || '').trim().toLowerCase().replace(/[.@#$/,-]/g, ' ').trim();

  return relevantSearch({
    query: data.query,
    col: 'users'
  }).then((data) => {
    return Promise.all(data.map((item) => {
      return admin.firestore().collection('users').doc(item.id).get().then((doc) => {
        return {
          id: item.id,
          ...doc.data()
        };
      });
    }));
  });
});
