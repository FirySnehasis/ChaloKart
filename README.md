# ChaloKart Driver

## Overview
ChaloKart Driver is a Flutter-based mobile application designed for ride-hailing service drivers. This app provides a comprehensive platform for drivers to receive ride requests, manage their availability, track earnings, and maintain their profile.

Here is the link to download the apk file for ChaloKart Driver : https://drive.google.com/drive/folders/1RefWNAbbGonp-d4KDjLwEIVUawiW2uYY?usp=sharing

## Features

### For Drivers
- **Real-time Location Tracking**: Utilizes Google Maps to track driver location in real-time
- **Online/Offline Status**: Drivers can toggle their availability status
- **Ride Request Management**: Accept or reject incoming ride requests
- **Navigation**: Turn-by-turn navigation to pickup and drop-off locations
- **Earnings Tracker**: Monitor daily, weekly, and monthly earnings
- **Rating System**: View and maintain driver ratings
- **Profile Management**: Update personal and vehicle information

### Technical Features
- **Firebase Integration**: Authentication, real-time database, cloud messaging, and storage
- **Push Notifications**: Real-time alerts for new ride requests
- **Geolocation Services**: Precise location tracking and geocoding
- **Google Maps Integration**: Interactive maps with real-time updates
- **Theme Support**: Light and dark mode support

## Getting Started

### Prerequisites
- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode
- Firebase account and project setup
- Google Maps API key

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/chalo_kart_driver.git
   ```

2. Navigate to the project directory:
   ```
   cd chalo_kart_driver
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Configure Firebase:
   - Create a Firebase project
   - Enable Authentication, Realtime Database, Storage, and Cloud Messaging
   - Add your Android/iOS app to the Firebase project
   - Download and add the google-services.json/GoogleService-Info.plist to the appropriate directory

5. Configure Google Maps:
   - Obtain a Google Maps API key
   - Enable required APIs (Maps SDK for Android/iOS, Directions API, Places API)
   - Add the API key to the AndroidManifest.xml and AppDelegate.swift/AppDelegate.m files

6. Run the application:
   ```
   flutter run
   ```

## Architecture and Directory Structure

- **lib/screens/**: Main application screens
- **lib/models/**: Data models
- **lib/services/**: Services for API calls, location, etc.
- **lib/widgets/**: Reusable UI components
- **lib/utils/**: Utility functions and constants
- **lib/tab_pages/**: Tab-specific screens
- **lib/themeProvider/**: Theme configuration
- **lib/global/**: Global variables and configurations
- **lib/pushNotification/**: Push notification system
- **lib/Assistance/**: Helper methods for various features

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Firebase**: Backend services
- **Google Maps**: Location and navigation services
- **Geolocator**: Precise location tracking
- **Provider**: State management
- **Flutter Polyline Points**: Route visualization

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any inquiries, please reach out to [your-email@example.com](mailto:your-email@example.com)
