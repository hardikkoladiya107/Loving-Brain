const fs = require('fs');

const authControllerPath = 'functions/controllers/authController.js';
let content = fs.readFileSync(authControllerPath, 'utf8');

// 1. Remove defineSecret require
content = content.replace(/const \{ defineSecret \} = require\("firebase-functions\/params"\);.*\n/, '');

// 2. Remove brevoApiKeySecret definition
content = content.replace(/const brevoApiKeySecret = defineSecret\("BREVO_API_KEY"\);.*\n/, '');

// 3. Remove { secrets: [brevoApiKeySecret] } from onCall
content = content.replace(/onCall\(\{ secrets: \[brevoApiKeySecret\] \}, async \(request\) => \{/, 'onCall(async (request) => {');

// 4. Replace brevoApiKeySecret.value() with process.env.BREVO_API_KEY
content = content.replace(/const apiKey = brevoApiKeySecret\.value\(\);/, 'const apiKey = process.env.BREVO_API_KEY;');

fs.writeFileSync(authControllerPath, content);
