


# **Lifeastab Audio Library - Sermon Management System**

A Flutter-based web application for managing and streaming audio sermons, with separate admin and user interfaces built for web deployment.

## 🚀 Live Sites

- **User Web App**: *Coming Soon*
- **Admin Web App**: *Coming Soon*

## 📁 Project Structure

```
sermon_app/
├── user_webapp/                 # Frontend for end users
│   ├── lib/                     # Flutter Dart source code
│   ├── web/                     # Web-specific configuration
│   ├── pubspec.yaml             # Dependencies and metadata
│   ├── build/web/               # Web build output (generated)
│   └── firebase.json            # Firebase Hosting configuration
└── admin_webapp/                # Admin dashboard
    ├── lib/                     # Flutter Dart source code
    ├── pubspec.yaml             # Dependencies and metadata  
    ├── build/web/               # Web build output (generated)
    └── firebase.json            # Firebase Hosting configuration
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+ (Web)
- **Backend Services**: Firebase
  - Firebase Hosting (Web deployment)
  - Firestore Database (Data storage)
  - Firebase Authentication (User management)
  - Google Drive (Audio file storage)
- **State Management**: Provider/Riverpod
- **Audio Playback**: Just Audio / Assets Audio Player
- **UI Components**: Flutter Material Design

## 🎯 Features

### User Web App
- ✅ **Audio Player**: Stream sermons with full playback (Feature available in future updates) controls
- ✅ **Sermon Library**: Browse and search sermon collection
- ✅ **Categories**: Filter sermons by topics, speakers, or series
- ✅ **Playlists**: Create and manage personal playlist (Feature available in future updates)
- ✅ **User Profiles**: Personalize listening experience (Feature available in future updates)
- ✅ **Progress Tracking**: Resume sermons from last position (Feature available in future updates)
- ✅ **Download Options**: Offline listening capability

### Admin Web App  
- ✅ **Dashboard**: Analytics and overview metrics
- ✅ **Sermon Management**: Upload, edit, and delete sermons
- ✅ **User Management**: Manage user accounts and permissions
- ✅ **Content Organization**: Categorize and tag sermons
- ✅ **Analytics**: Track listening statistics and user engagement (Feature available in future updates)
- ✅ **Bulk Operations**: Import/export sermon data 

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Firebase CLI
- Git


## 🔧 Development

### Running Locally
```bash
# User app
cd user_webapp
flutter run -d chrome --web-renderer html

# Admin app  
cd admin_webapp
flutter run -d chrome --web-renderer html
```


### Performance Tips
- Use `--web-renderer html` for better compatibility
- Optimize audio file sizes and formats
- Enable tree shaking in pubspec.yaml

## 📊 Browser Support

| Browser | Version | Support |
|---------|---------|---------|
| Chrome | 90+ | ✅ Full |
| Firefox | 88+ | ✅ Full |
| Safari | 14+ | ✅ Full |
| Edge | 90+ | ✅ Full |



## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Version**: 1.0.0  
**Last Updated**: October 2024  
**Flutter Version**: 3.0+  
**Firebase**: Booster Plan