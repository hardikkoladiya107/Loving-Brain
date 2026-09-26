const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

async function check() {
  const email = 'parth.flutter.dev@yopmail.com';
  const doc = await db.collection('otps').doc(email).get();
  if (doc.exists) {
    console.log('OTP Data:', doc.data());
  } else {
    console.log('No OTP found for ' + email);
  }
}
check();
