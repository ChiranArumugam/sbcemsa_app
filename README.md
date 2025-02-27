# Santa Barbara County EMS Agency (SBCEMSA) Mobile App

**IMPORTANT NOTICE: This is a personal project and NOT the official Santa Barbara County EMS Agency application.** This app was created as an independent resource to help EMS professionals but is not affiliated with, endorsed by, or officially connected to the Santa Barbara County EMS Agency.

A comprehensive mobile application designed for Emergency Medical Services (EMS) providers in Santa Barbara County, California. This app serves as a digital resource hub for protocols, medications, hospital information, and other essential tools for EMS professionals.

## Features

- **PDF Library**: Access to protocols, guidelines, and reference materials
- **Medication Database**: Quick reference for medication dosages and information
- **Hospital Directory**: Contact information and directions to local hospitals
- **Pediatric Dose Calculator**: Tool for calculating pediatric medication dosages
- **Notes System**: Create and manage personal notes
- **Offline Access**: Access critical information without internet connection

## Tech Stack

- **Framework**: Flutter (Dart)
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **PDF Handling**: pdfrx
- **Storage**: shared_preferences, path_provider
- **Networking**: http, connectivity_plus
- **Maps Integration**: maps_launcher, flutter_map
- **UI Components**: lottie (animations), sliding_up_panel, badges

## Getting Started

### Prerequisites

- Flutter SDK (version 3.5.3 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile deployment)

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/sbcemsa_app.git
   ```

2. Navigate to the project directory
   ```
   cd sbcemsa_app
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the application
   ```
   flutter run
   ```

## Building for Production

### Android
```
flutter build apk --release
```

### iOS
```
flutter build ios --release
```

## Data Sources

This application references information from the Santa Barbara County Emergency Medical Services Agency. For the most up-to-date official information, please visit:
- [Santa Barbara County EMS Agency Website](https://www.countyofsb.org/2024/EMS-Agency/)

## License

This project is a personal initiative intended to help Santa Barbara County EMS providers. All medical information contained within this application should be verified against official protocols and guidelines.

### Disclaimer

**This is NOT an official application of the Santa Barbara County EMS Agency.** The information provided in this application is for reference purposes only. Always follow your agency's official protocols and medical direction. In case of any discrepancy between the information in this app and official protocols, the official protocols take precedence.

## Contact

For bug reports, feature requests, or other inquiries, please contact the developer at:
- Email: chiran.aru@icloud.com

## Acknowledgments

- Santa Barbara County Emergency Medical Services Agency for their publicly available reference materials and protocols
- All EMS providers in Santa Barbara County for their dedicated service
