Project Management App - README

1. Project Overview

Project Name: Project Management App

Description: This Flutter application is designed to help users efficiently manage their projects. It provides functionalities for task tracking, project categorization (bugs, completed, in-progress, to-do), user authentication, and basic communication features.

Key Features:
 User Authentication: Secure login and registration.
 Project Management: Create, view, and organize projects.
 Task Categorization: Track project tasks by status (Bugs, Completed, In Progress, To Do).
 Detailed Project Pages: View comprehensive details for each project.
 Reporting: Access project-related reports.
 Chat Functionality (Basic): Limited chat capabilities for communication .

2. Prerequisites

Before running this project, ensure you have the following installed on your system:

 Flutter SDK:
     Version: `Flutter 3.29.0`
     Channel: `stable`
     Source: `https://github.com/flutter/flutter.git`
 Dart SDK:
     Version: `Dart 3.7.0`
 DevTools: 
     Version: `DevTools 2.42.2`
 Android Studio:  Required for Android development tools and emulator.
 Emulator or Physical Device: An Android emulator or a physical Android phone to run the application.

3. Getting Started

Follow these step-by-step instructions to set up and run the `Project Management App` on your local machine.

 3.1. Clone the Repository
First, clone the project repository to your local machine using Git:
git clone https://github.com/AlpBost/CurlyWare

 3.2. Navigate to the Project Directory
Change your current directory to the cloned project folder:
cd curlyware

 3.3. Install Dependencies
Fetch all the necessary Flutter and Dart packages:
flutter pub get

3.4. Firebase Setup
This project uses Firebase for authentication and possibly other backend services. You need to configure Firebase for your project.

Create a Firebase Project:

Go to the Firebase Console.
Click "Add project" and follow the steps to create a new Firebase project.
Add Android App to Firebase Project:

In your Firebase project, click the Android icon to add an Android app.
Android package name: This must match your Flutter project's package name. You can find it in android/app/build.gradle under defaultConfig { applicationId "com.example.jjj" } (usually com.example.jjj).
App nickname (optional): A friendly name for your app.
SHA-1 debug signing certificate (for authentication):
Open your project in Android Studio.
Go to Gradle (on the right sidebar) -> curlyware -> Tasks -> android -> signingReport.
Double-click signingReport to run it. In the "Run" window at the bottom, copy the SHA1 fingerprint.
Paste the SHA1 fingerprint into the Firebase console.
Register your app.
Download google-services.json:

After registering, download the google-services.json file.
Place this file into the android/app/ directory of your Flutter project.
Configure Firebase Project Settings (if not already done by flutterfire configure):

If you have run flutterfire configure: The lib/firebase_options.dart file should be automatically generated.
If firebase_options.dart is missing or incorrect:
Install Firebase CLI: npm install -g firebase-tools
Log in to Firebase: firebase login
Run FlutterFire configuration from your project root:
flutterfire configure

Follow the prompts to connect your Flutter project to your Firebase project. This will generate/update lib/firebase_options.dart.

 3.5. Run the Application
Connect an Android emulator or a physical Android device to your computer. Then, run the application:
flutter run



4. Project Structure (lib directory)
The lib directory is organized into logical modules to maintain code readability and separation of concerns:

lib/
├── auth/                       // Authentication related services and checks
│   ├── auth_check.dart
│   └── auth_service.dart
├── pages/
│   ├── chat/                   // Chat related UI and services
│   │   ├── chat_page.dart
│   │   ├── chat_service.dart
│   │   ├── message.dart
│   │   └── messagepage.dart
│   │   └── user_tile.dart
│   ├── LoginAndRegister/       // Login and Registration UI
│   │   ├── loginpage.dart
│   │   └── registerpage.dart
│   ├── mainpage/               // Main application features and UI
│   │   ├── DetailedPages/      // Detailed project view and task status pages
│   │   │   ├── bugsPage.dart
│   │   │   ├── completedPage.dart
│   │   │   ├── inProgressPage.dart
│   │   │   ├── ProjectDetailPage.dart
│   │   │   ├── toDoPage.dart
│   │   │   ├── mainpagebuttons.dart
│   │   │   ├── ProjectsController.dart
│   │   │   └── projecttypes.dart
│   │   └── reportpage/         // Reporting features
│   │       └── reportspage.dart
│   ├── bottombar.dart          // Navigation bar component
│   ├── firebase_options.dart   // Firebase configuration 
│   └── main.dart               // Application entry point



5. Video Link

6. Contributors

Alp Bostancı
Mehmet Şakir Şeker
