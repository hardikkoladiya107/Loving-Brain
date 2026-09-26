const fs = require('fs');
const path = 'functions/controllers/authController.js';
let content = fs.readFileSync(path, 'utf8');

const tryCatchRegex = /try \{\s*const response = await fetch\([\s\S]*?if \(!response\.ok\) \{[\s\S]*?\}\s*\} catch \(error\) \{/m;
const newTryCatch = 	ry {
    const response = await fetch(BREVO_API_URL, {
      method: "POST",
      headers: {
        "api-key": apiKey,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify({
        sender: { name: SENDER_NAME, email: SENDER_EMAIL },
        to: [{ email: email }],
        subject: "Your Loving Brain Verification Code",
        htmlContent: \\\<p>Your verification code is: <strong>\</strong></p><p>This code will expire in 10 minutes.</p>\\\,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      logger.error(\\\Brevo email failed with status \\\: \\\\\\);
      throw new HttpsError("internal", "Failed to send OTP email via Brevo.");
    }
    
    // Add success logging here
    const successData = await response.json();
    logger.info(\\\Brevo email sent successfully! Response: \\\\\\);

  } catch (error) {;

content = content.replace(tryCatchRegex, newTryCatch);
fs.writeFileSync(path, content);
