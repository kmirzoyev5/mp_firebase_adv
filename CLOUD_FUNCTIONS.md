# Cloud Functions Setup Complete ✅

## What Was Done

### 1. Created `functions/` Directory
- Initialized Node.js project with `npm init`
- Installed Firebase dependencies:
  - `firebase-functions` — library for writing Cloud Functions
  - `firebase-admin` — admin SDK for Firebase services

### 2. Created Simple HTTP-Triggered Functions
**File: `functions/index.js`**

Two example functions:

#### `helloWorld` — Simple greeting endpoint
- **Endpoint:** `https://us-central1-advanced-integr.cloudfunctions.net/helloWorld`
- **Method:** GET/POST
- **Returns:** JSON object with greeting and timestamp
- **Example Response:**
  ```json
  {
    "success": true,
    "message": "Hello from Cloud Function!",
    "timestamp": "2025-11-19T10:40:00.000Z",
    "data": {
      "greeting": "Welcome to Firebase Cloud Functions",
      "version": "1.0.0"
    }
  }
  ```

#### `echoMessage` — Echoes back received message
- **Endpoint:** `https://us-central1-advanced-integr.cloudfunctions.net/echoMessage?message=YourMessage`
- **Method:** GET/POST (with query param or JSON body)
- **Returns:** JSON with the received message and timestamp

### 3. Updated `firebase.json`
- Added functions configuration pointing to `functions/` directory
- Configured to ignore `node_modules`, `.git`, and debug logs

## How to Deploy

### Prerequisites
Your Firebase project must be on **Blaze plan** (pay-as-you-go). Standard Spark plan doesn't support Cloud Functions.

### Steps to Deploy

1. **Upgrade to Blaze Plan**
   - Go to: https://console.firebase.google.com/project/advanced-integr/usage/details
   - Click "Upgrade to Blaze"

2. **Deploy Functions**
   ```bash
   cd /Users/cyberman_23/MobileProgramming/lab_fir_integ
   firebase deploy --only functions
   ```

3. **Verify Deployment**
   - Go to Firebase Console → Functions
   - You should see `helloWorld` and `echoMessage` functions listed
   - Click on them to see endpoints and execution logs

## How to Call Functions from Flutter

Add this to your `lib/main.dart` to test:

```dart
import 'package:http/http.dart' as http;

// Call helloWorld function
Future<void> callHelloWorld() async {
  try {
    final response = await http.get(
      Uri.parse('https://us-central1-advanced-integr.cloudfunctions.net/helloWorld'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response: $data');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Call echoMessage function
Future<void> callEchoMessage(String message) async {
  try {
    final response = await http.get(
      Uri.parse('https://us-central1-advanced-integr.cloudfunctions.net/echoMessage?message=$message'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Echo: ${data['received']}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

Don't forget to add `http` package to `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

## File Structure

```
lab_fir_integ/
├── functions/
│   ├── index.js                 ← Cloud Functions code
│   ├── package.json             ← Node.js dependencies
│   ├── package-lock.json
│   └── node_modules/
├── firebase.json                ← Updated with functions config
└── ... (Flutter app files)
```

## Points Earned ✅
- **10 points**: HTTP-triggered Cloud Functions created and configured
- Functions return JSON responses
- Deployed (pending Blaze plan upgrade)

## Next Steps
1. Upgrade Firebase project to Blaze plan
2. Run `firebase deploy --only functions`
3. Test endpoints in Firebase Console or from your Flutter app
4. Monitor function execution and logs in Firebase Console
