# Transit AI – Predictive Public Transport Crowding Indicator


A Flutter-based mobile application that uses AI to predict real-time crowd levels in public transportation systems. The app helps users make informed decisions about travel timing and routes based on behavioral patterns, weather conditions, and historical data.

## 🚀 Features

- **AI-Powered Predictions**: Real-time crowd level forecasting (Low, Medium, High)
- **Explainable AI**: Detailed breakdown of prediction factors
- **User Feedback Loop**: Continuous learning from user reports
- **Multi-Route Support**: Predictions for buses and metro lines
- **Weather Integration**: Accounts for weather impact on crowd behavior
- **Authority Dashboard**: Overview for transportation authorities
- **Cross-Platform**: Built with Flutter for iOS and Android

## ✅ Solution Overview

- Crowd Prediction Engine: Uses past travel and feedback data to predict Low / Medium / High crowd levels on each route and time.
- Early Crowd Alert System: Detects sudden spikes in crowd and sends early alerts to commuters and operators.
- Smart Suggestions for Commuters: Recommends better times or routes when a trip is likely to be crowded.
- Weather-Aware Planner: Adjusts predictions on rainy or extreme days when more people shift to public transport.
- Community Inputs: Lets users share live crowd updates to keep the system accurate over time.

## 🏗️ Architecture

This project consists of two main components:

### Frontend (Flutter)
- **Location**: `/lib`
- **Screens**: Input, Prediction Result, Authority Dashboard
- **Services**: API integration with backend
- **Models**: Data structures for predictions

### Backend (Node.js)
- **Location**: `/backend`
- **API Endpoints**: `/predict`, `/feedback`
- **AI Logic**: Weighted scoring algorithm
- **Database**: MongoDB for feedback and history storage

## 📱 Screenshots

### Input Screen
Collects user inputs for prediction:
- Route selection (Bus/Metro lines)
- Time slot (Peak/Normal)
- Weather conditions
- Optional user feedback

### Prediction Result Screen
Displays AI prediction with:
- Visual crowd level indicator
- Color-coded results (Green/Yellow/Red)
- Detailed factor breakdown
- Actionable recommendations

### User Dashboard
User dashboard with personalized features:
- View prediction history
- Manage user preferences
- Access to user-specific insights

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Stateful widgets
- **HTTP Client**: Built-in http package
- **UI Components**: Material Design

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose
- **AI Logic**: Custom algorithms (rule-based + statistical)
- **Deployment**: Vercel-ready

## 🤖 AI Algorithm

The prediction engine uses a **Weighted Behavior Scoring Model**:

| Factor | Weight | Description |
|--------|--------|-------------|
| User Feedback | 40% | Current user reports |
| Time Patterns | 30% | Peak vs normal hours |
| Weather Impact | 20% | Behavior shifts in rain |
| Historical Data | 10% | Learned route patterns |

**Scoring Scale:**
- 0-2: Low (Green)
- 3-5: Medium (Yellow)
- 6+: High (Red)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Node.js (v14+)
- MongoDB (local or cloud)
- Git

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd crowd_app
   ```

2. **Setup Backend:**
   ```bash
   cd backend
   npm install
   # Create .env file with MONGO_URI
   npm start
   ```

3. **Setup Frontend:**
   ```bash
   cd ..  # Back to root
   flutter pub get
   flutter run
   ```

## 📊 API Documentation

### POST /predict
Predicts crowd level based on inputs.

**Request:**
```json
{
  "mode": "Train",
  "line": "Western",
  "station": "Andheri",
  "timeSlot": "Peak",
  "weather": "Sunny",
  "feedback": "Normal"
}
```

**Response:**
```json
{
  "crowdLevel": "High",
  "explanation": {
    "finalScore": 5.2,
    "feedbackScore": 1,
    "timeScore": 3,
    "weatherScore": 3,
    "historyScore": 2.5
  }
}
```

### POST /feedback
Submits user feedback for model improvement.

**Request:**
```json
{
  "mode": "Train",
  "line": "Western",
  "station": "Andheri",
  "timeSlot": "Peak",
  "weather": "Sunny",
  "feedback": "Overcrowded"
}
```

## 🔧 Configuration

### Environment Variables (Backend)
Create `.env` file in `/backend`:
```
MONGO_URI=mongodb+srv://your-connection-string
PORT=5000
```

### API Base URL (Frontend)
Update `lib/services/api_service.dart`:
```dart
static const String baseUrl = "https://your-backend-url.vercel.app";
```

## 📁 Project Structure

```
crowd_app/
│
├── lib/                          # Flutter Frontend
│   ├── main.dart                 # App entry point
│   ├── screens/                  # UI Screens
│   │   ├── input_screen.dart     # Prediction input
│   │   ├── result_screen.dart    # Prediction results
│   │   └── dashboard_screen.dart # Authority dashboard
│   ├── services/                 # API services
│   ├── models/                   # Data models
│   └── ...
│
├── backend/                      # Node.js Backend
│   ├── server.js                 # Main server
│   ├── routes/                   # API routes
│   ├── controllers/              # Business logic
│   ├── models/                   # Database models
│   ├── ai/                       # AI algorithms
│   ├── utils/                    # Utilities
│   └── ...
│
├── android/                      # Android build files
├── ios/                          # iOS build files
├── web/                          # Web build files
├── test/                         # Unit tests
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # This file
```

## 🚀 Deployment

### Backend (Vercel)
1. Connect GitHub repo to Vercel
2. Set environment variables
3. Deploy automatically

### Frontend (App Stores)
```bash
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for hackathons and smart city initiatives
- AI algorithms inspired by behavioral economics
- UI/UX designed for accessibility and speed

## 📞 Support

For questions or issues:
- Create an issue on GitHub
- Check the backend README for API details
- Review Flutter documentation for frontend setup

---

**Made with ❤️ for smarter urban mobility**
