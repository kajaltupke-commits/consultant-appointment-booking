# Consultant Appointment Booking Application

A Flutter-based mobile application developed to simplify the process of booking appointments with consultants. Users can register and log in, browse consultants, view consultant details, book appointments, view appointments, receive notifications, and manage their profile.

## 📱 Project Overview

The Consultant Appointment Booking Application provides a simple and user-friendly platform for users to find consultants and book appointments.

The application is developed using Flutter and Dart and uses Firebase services for authentication and data management.

## ✨ Features

- User Registration
- User Login
- Forgot Password
- Firebase Authentication
- Home Screen
- Browse Consultants
- View Consultant Details
- Book Appointment
- Select Appointment Date
- Select Appointment Time
- Booking Confirmation
- View Appointments
- Cancel Appointments
- Notifications
- Profile Management
- Firebase Integration
- Cloud Firestore Integration
- Reusable UI Components

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language |
| Firebase Core | Firebase integration |
| Firebase Authentication | User authentication |
| Cloud Firestore | Data storage and management |
| Git | Version control |
| GitHub | Source code repository |

## 📂 Project Structure

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   └── widgets/
│       ├── app_logo.dart
│       ├── consultant_card.dart
│       ├── primary_button.dart
│       └── section_title.dart
│
├── data/
│   └── mock_data.dart
│
├── models/
│   ├── appointment.dart
│   └── consultant.dart
│
├── screens/
│   ├── appointment/
│   │   ├── appointments_screen.dart
│   │   ├── booking_screen.dart
│   │   └── booking_success_screen.dart
│   │
│   ├── auth/
│   │   ├── forgot_password_screen.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   │
│   ├── consultant/
│   │   └── consultant_details_screen.dart
│   │
│   ├── home/
│   │   └── home_screen.dart
│   │
│   ├── notifications/
│   │   └── notifications_screen.dart
│   │
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   │
│   ├── profile/
│   │   └── profile_screen.dart
│   │
│   └── splash/
│       └── splash_screen.dart
│
├── services/
│   ├── appointment_service.dart
│   └── auth_services.dart
│
├── app.dart
├── firebase_options.dart
└── main.dart

## 🔥 Firebase Integration

The application uses Firebase for backend functionality.

### Firebase Authentication

Firebase Authentication is used for:

- User registration
- User login
- Forgot password
- User authentication

### Cloud Firestore

Cloud Firestore is used for storing and managing application data related to:

- Users
- Consultants
- Appointments

## 📅 Appointment Booking Workflow

```text
Start Application
       ↓
Splash Screen
       ↓
Onboarding Screen
       ↓
Login / Register
       ↓
Home Screen
       ↓
Browse Consultants
       ↓
Select Consultant
       ↓
View Consultant Details
       ↓
Book Appointment
       ↓
Select Date and Time
       ↓
Confirm Appointment
       ↓
Booking Successful
       ↓
View / Manage Appointments

## 📱 Application Screens

### Splash Screen

The splash screen is displayed when the application starts.

### Onboarding Screen

The onboarding screen introduces users to the application.

### Authentication Screens

The authentication section includes:

- Login
- Registration
- Forgot Password

### Home Screen

The home screen provides access to the main features of the application and available consultants.

### Consultant Section

Users can browse consultants and view detailed information about a selected consultant.

### Appointment Section

The appointment section includes:

- Appointments Screen
- Booking Screen
- Booking Success Screen

Users can book and manage their consultant appointments.

### Notifications Screen

The notifications screen displays appointment-related notifications.

### Profile Screen

The profile screen allows users to view and manage their profile.

## 🧩 Core Components

The application contains reusable components to maintain a consistent user interface.

### Constants

```text
lib/core/constants/
├── app_colors.dart
└── app_strings.dart

### Theme

```text
lib/core/theme/
└── app_theme.dart

### widgets
lib/core/widgets/
├── app_logo.dart
├── consultant_card.dart
├── primary_button.dart
└── section_title.dart

## 📊 Data Models
The application uses data models to represent application information.

### Consultant Model

`lib/models/consultant.dart`
Represents consultant information.

### Appointment Model

`lib/models/appointment.dart`
Represents appointment information.

## 🗃️ Data
The project contains mock data used by the application.

`lib/data/mock_data.dart`

## ⚙️ Services
The application contains separate services for authentication and appointment-related operations.

### Appointment Service

`lib/services/appointment_service.dart`
Handles appointment-related operations.

### Authentication Service

`lib/services/auth_services.dart`
Handles authentication-related operations.

## 🚀 Getting Started

### Prerequisites
Before running the project, make sure you have:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android Emulator or physical Android device
- Firebase project
- Git

### Clone the Repository

```bash
git clone https://github.com/kajaltupke-commits/consultant-appointment-booking.git

### Navigate to the Project
```bash
cd consultant-appointment-booking

### Install Dependencies
```bash
flutter pub get

### Check Flutter Setup
```bash
flutter doctor

### Run the Application
```bash
flutter run

## 🧪 Testing
To analyze the Flutter project, run:
```bash
flutter analyze

The application can be tested using:

- Android Emulator
- Physical Android Device
- Debug Build
- Release Build

## 📦 Build Release APK
To create a release APK, run:
```bash
flutter build apk --release

The generated APK will be available at:
```text
build/app/outputs/flutter-apk/app-release.apk
flutter build apk --release

The generated APK will be available at:
```text
build/app/outputs/flutter-apk/app-release.apk

## 🎯 Project Objective

The main objective of this project is to develop a Flutter-based Consultant Appointment Booking Application that makes it easier for users to find consultants and book appointments.

The project demonstrates practical knowledge of:

- Flutter application development
- Dart programming
- UI/UX design
- Firebase Authentication
- Cloud Firestore
- Application navigation
- Data modelling
- Reusable widgets
- Appointment booking and management

## 👥 Project Information

**Project Title:** Consultant Appointment Booking Application

**Project Type:** Academic Group Project

**Platform:** Android

**Framework:** Flutter

**Programming Language:** Dart

**Backend:** Firebase

**Database:** Cloud Firestore

**Authentication:** Firebase Authentication

## 📌 GitHub Repository
[Consultant Appointment Booking Application](https://github.com/kajaltupke-commits/consultant-appointment-booking)

## 🎓 Academic Project
This application was developed as an academic group project to demonstrate practical knowledge of Flutter mobile application development, Dart programming, Firebase integration, authentication, database management, UI design, and consultant appointment booking.

## 📄 License
This project is developed for educational and academic purposes.
