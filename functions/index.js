const functions = require("firebase-functions");

// HTTP-triggered function that returns JSON
exports.helloWorld = functions.https.onRequest((request, response) => {
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Methods", "GET, POST");
  response.set("Access-Control-Allow-Headers", "Content-Type");

  if (request.method === "OPTIONS") {
    response.status(204).send("");
    return;
  }

  // Return JSON response
  response.json({
    success: true,
    message: "Hello from Cloud Function!",
    timestamp: new Date().toISOString(),
    data: {
      greeting: "Welcome to Firebase Cloud Functions",
      version: "1.0.0",
    },
  });
});

// Another HTTP function that echoes back data
exports.echoMessage = functions.https.onRequest((request, response) => {
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Methods", "GET, POST");
  response.set("Access-Control-Allow-Headers", "Content-Type");

  if (request.method === "OPTIONS") {
    response.status(204).send("");
    return;
  }

  const message = request.query.message || request.body.message || "No message provided";

  response.json({
    success: true,
    received: message,
    timestamp: new Date().toISOString(),
  });
});
