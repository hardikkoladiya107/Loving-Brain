/**
 * Brainy AI callables — OpenAI stays server-side.
 * Requires OPENAI_API_KEY in the function environment.
 */
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const {
  isOlderThanRetentionDays,
  CONVERSATION_RETENTION_DAYS,
} = require("../services/brainyRetention");

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const OPENAI_CHAT_URL = "https://api.openai.com/v1/chat/completions";
const OPENAI_TRANSCRIBE_URL = "https://api.openai.com/v1/audio/transcriptions";

/**
 * @return {string}
 */
function requireOpenAiKey() {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    logger.error("OPENAI_API_KEY configuration is missing at runtime.");
    throw new HttpsError("failed-precondition", "AI service is unconfigured.");
  }
  return apiKey;
}

/**
 * @param {import('firebase-functions/v2/https').CallableRequest} request
 */
function requireAuth(request) {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  return request.auth.uid;
}

/**
 * brainyChat
 * Accepts systemPrompt, history, messageText, optional imageUrls.
 * Returns { text: string }.
 */
exports.brainyChat = onCall(
    {
      timeoutSeconds: 60,
      memory: "512MiB",
    },
    async (request) => {
      requireAuth(request);
      const apiKey = requireOpenAiKey();
      const data = request.data || {};
      const messageText =
      typeof data.messageText === "string" ? data.messageText.trim() : "";
      if (!messageText) {
        throw new HttpsError("invalid-argument", "messageText is required.");
      }

      const systemPrompt =
      typeof data.systemPrompt === "string" && data.systemPrompt.trim()
        ? data.systemPrompt.trim()
        : "You are a helpful parenting assistant for LovingBrain.";

      const messages = [
        {role: "system", content: systemPrompt},
      ];

      if (Array.isArray(data.history)) {
        for (const item of data.history) {
          if (!item || typeof item !== "object") continue;
          const role = item.role === "assistant" ? "assistant" : "user";
          const content =
          typeof item.content === "string" ? item.content : "";
          if (content.trim()) {
            messages.push({role, content});
          }
        }
      }

      const imageUrls = Array.isArray(data.imageUrls)
        ? data.imageUrls.filter((u) => typeof u === "string" && u.trim())
        : [];

      if (imageUrls.length > 0) {
        const content = [{type: "text", text: messageText}];
        for (const url of imageUrls) {
          content.push({
            type: "image_url",
            image_url: {url},
          });
        }
        messages.push({role: "user", content});
      } else {
        messages.push({role: "user", content: messageText});
      }

      let response;
      try {
        response = await fetch(OPENAI_CHAT_URL, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${apiKey}`,
          },
          body: JSON.stringify({
            model: "gpt-4o",
            messages,
            temperature: 0.7,
          }),
        });
      } catch (err) {
        logger.error("OpenAI chat network error", err);
        throw new HttpsError("internal", "Failed to reach AI service.");
      }

      if (!response.ok) {
        const bodyText = await response.text().catch(() => "");
        logger.error("OpenAI chat error", {
          status: response.status,
          body: bodyText.slice(0, 500),
        });
        throw new HttpsError("internal", "AI service returned an error.");
      }

      const json = await response.json();
      const text =
      json?.choices?.[0]?.message?.content?.toString()?.trim() || "";
      if (!text) {
        throw new HttpsError("internal", "Empty AI response.");
      }
      return {text};
    },
);

/**
 * transcribeAudio
 * Accepts base64 audio + mimeType + fileName.
 * Returns { text: string }.
 */
exports.transcribeAudio = onCall(
    {
      timeoutSeconds: 60,
      memory: "512MiB",
    },
    async (request) => {
      requireAuth(request);
      const apiKey = requireOpenAiKey();
      const data = request.data || {};
      const base64 =
      typeof data.audioBase64 === "string" ? data.audioBase64.trim() : "";
      if (!base64) {
        throw new HttpsError("invalid-argument", "audioBase64 is required.");
      }

      const mimeType =
      typeof data.mimeType === "string" && data.mimeType.trim()
        ? data.mimeType.trim()
        : "audio/m4a";
      const fileName =
      typeof data.fileName === "string" && data.fileName.trim()
        ? data.fileName.trim()
        : "audio.m4a";

      let buffer;
      try {
        buffer = Buffer.from(base64, "base64");
      } catch (err) {
        throw new HttpsError("invalid-argument", "Invalid audioBase64.");
      }
      if (!buffer.length) {
        throw new HttpsError("invalid-argument", "Empty audio payload.");
      }

      const form = new FormData();
      form.append(
          "file",
          new Blob([buffer], {type: mimeType}),
          fileName,
      );
      form.append("model", "whisper-1");

      let response;
      try {
        response = await fetch(OPENAI_TRANSCRIBE_URL, {
          method: "POST",
          headers: {
            Authorization: `Bearer ${apiKey}`,
          },
          body: form,
        });
      } catch (err) {
        logger.error("OpenAI transcribe network error", err);
        throw new HttpsError("internal", "Failed to reach transcription.");
      }

      if (!response.ok) {
        const bodyText = await response.text().catch(() => "");
        logger.error("OpenAI transcribe error", {
          status: response.status,
          body: bodyText.slice(0, 500),
        });
        throw new HttpsError("internal", "Transcription failed.");
      }

      const json = await response.json();
      const text = typeof json?.text === "string" ? json.text.trim() : "";
      return {text};
    },
);

/**
 * Deletes chats subcollection + Storage objects, then the conversation doc.
 * @param {string} uid
 * @param {FirebaseFirestore.DocumentReference} convRef
 */
async function deleteConversationTree(uid, convRef) {
  const chatsSnap = await convRef.collection("chats").get();
  const storage = admin.storage().bucket();
  const batchSize = 400;
  let batch = db.batch();
  let ops = 0;

  for (const chatDoc of chatsSnap.docs) {
    const data = chatDoc.data() || {};
    const urls = [];
    if (typeof data.image_network_path === "string" &&
        data.image_network_path) {
      urls.push(data.image_network_path);
    }
    if (Array.isArray(data.image_network_paths)) {
      for (const u of data.image_network_paths) {
        if (typeof u === "string" && u) urls.push(u);
      }
    }
    if (typeof data.audio_network_path === "string" &&
        data.audio_network_path) {
      urls.push(data.audio_network_path);
    }
    for (const url of urls) {
      try {
        const match = url.match(/\/o\/([^?]+)/);
        if (match && match[1]) {
          const path = decodeURIComponent(match[1]);
          await storage.file(path).delete({ignoreNotFound: true});
        }
      } catch (err) {
        logger.warn("Storage delete skipped", {url, err: String(err)});
      }
    }
    batch.delete(chatDoc.ref);
    ops += 1;
    if (ops >= batchSize) {
      await batch.commit();
      batch = db.batch();
      ops = 0;
    }
  }
  if (ops > 0) {
    await batch.commit();
  }
  await convRef.delete();
}

/**
 * Daily cleanup of Brainy conversations older than retention window.
 * Saved guidance is left in place.
 */
exports.purgeExpiredBrainyConversations = onSchedule(
    {
      schedule: "every 24 hours",
      timeoutSeconds: 540,
      memory: "512MiB",
    },
    async () => {
      const usersSnap = await db.collection("users").select().get();
      const now = new Date();
      let deleted = 0;

      for (const userDoc of usersSnap.docs) {
        const convSnap = await userDoc.ref.collection("conversations").get();
        for (const convDoc of convSnap.docs) {
          const data = convDoc.data() || {};
          let createdAt = null;
          if (data.created_at && typeof data.created_at.toDate === "function") {
            createdAt = data.created_at.toDate();
          } else {
            const ms = Number(convDoc.id);
            if (!Number.isNaN(ms) && ms > 1000000000000) {
              createdAt = new Date(ms);
            }
          }
          if (!createdAt) continue;
          if (!isOlderThanRetentionDays(
              createdAt,
              now,
              CONVERSATION_RETENTION_DAYS,
          )) {
            continue;
          }
          try {
            await deleteConversationTree(userDoc.id, convDoc.ref);
            deleted += 1;
          } catch (err) {
            logger.error("Failed to purge conversation", {
              uid: userDoc.id,
              conversationId: convDoc.id,
              err: String(err),
            });
          }
        }
      }
      logger.info("Brainy retention purge complete", {
        deleted,
        retentionDays: CONVERSATION_RETENTION_DAYS,
      });
    },
);

exports.deleteConversationTree = deleteConversationTree;
