🎓 Student Attendance Management App
A comprehensive Flutter application for managing student attendance and assignments with Firebase backend integration. Built using Clean Architecture and BLoC state management pattern.


![WhatsApp Image 2026-01-21 at 3 05 06 PM](https://github.com/user-attachments/assets/5757cc46-3851-49eb-a095-31047394bb7a)


![WhatsApp Image 2026-01-21 at 3 04 56 PM](https://github.com/user-attachments/assets/5485f6f4-97d2-4298-b079-e51db6c8cf88)


![WhatsApp Image 2026-01-21 at 3 05 06 PM (1)](https://github.com/user-attachments/assets/821d2875-ef5a-48e2-b590-dc96b42547a5)


![WhatsApp Image 2026-01-21 at 3 05 06 PM (2)](https://github.com/user-attachments/assets/4768da01-0d61-4ca3-8bed-c758dfda01f8)


![WhatsApp Image 2026-01-21 at 3 05 07 PM](https://github.com/user-attachments/assets/1ea98675-d876-4da6-98d0-d262a4015a0d)


![WhatsApp Image 2026-01-21 at 3 05 07 PM (1)](https://github.com/user-attachments/assets/67e9b168-bbec-4186-bec8-4ed42150b99a)


![WhatsApp Image 2026-01-21 at 3 05 07 PM (2)](https://github.com/user-attachments/assets/9bb1b51b-f611-40cd-8079-bab1f61dfd79)



![WhatsApp Image 2026-01-21 at 3 05 08 PM](https://github.com/user-attachments/assets/0171eadc-0df3-4f4c-b65b-e43ea9485c6f)



📱 Features
🔐 Authentication

Email/Password authentication using Firebase
User registration with student details
Persistent login sessions (stays logged in after app restart)
Secure logout functionality
Auto-navigation based on authentication state

📊 Attendance Management

Mark daily attendance (Present/Absent/Leave)
Select specific dates for attendance marking
Add optional remarks for each attendance entry
View complete attendance history
Color-coded status indicators
Sort and filter attendance records

📚 Assignment Management

View all assigned assignments
Upload assignment files (PDF, DOC, DOCX, TXT)
Track assignment status (Pending/Submitted/Completed/Overdue)
File size validation (max 10MB)
Due date tracking with overdue indicators
Firebase Storage integration for file uploads

🎨 UI/UX Features

Clean and intuitive Material Design interface
Bottom navigation for easy access
Color-coded status badges
Loading states and progress indicators
Error handling with user-friendly messages
Confirmation dialogs for important actions
Responsive design

🏗️ Architecture

This project follows Clean Architecture principles with clear separation of concerns:
lib/
├── core/                    # Core functionality
│   ├── constants/          # App-wide constants (colors, strings, styles)
│   ├── utils/              # Utility classes and helpers
│   └── errors/             # Error handling
├── data/                   # Data layer
│   ├── models/            # Data models
│   ├── datasources/       # Firebase data sources
│   └── repositories/      # Repository implementations
├── domain/                 # Business logic layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Use cases
└── presentation/          # Presentation layer
    ├── bloc/              # BLoC state management
    ├── screens/           # UI screens
    └── widgets/           # Reusable widgets

    
Architecture Layers

Presentation Layer: UI components, screens, and BLoC state management
Domain Layer: Business logic, entities, and use cases
Data Layer: Data sources, models, and repository implementations

🛠️ Tech Stack

Framework: Flutter 3.0+
Language: Dart 3.0+
State Management: BLoC (flutter_bloc)
Backend: Firebase


🚀 Getting Started
Prerequisites

Flutter SDK (3.0 or higher)
Dart SDK (3.0 or higher)
Firebase account
Android Studio / VS Code
Git
