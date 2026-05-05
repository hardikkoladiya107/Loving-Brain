const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const {handleEnergyBridgeWrite} = require("../services/energyBridgeService");

if (!admin.apps.length) admin.initializeApp();

exports.onEnergyBridgeWrite = onDocumentWritten("energy_bridge/{childId}",
    async (event) => {
      await handleEnergyBridgeWrite(event);
    });
