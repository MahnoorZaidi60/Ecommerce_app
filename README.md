# ecommerce_app

a full ecommerce app

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


App Structure:  

lib/
├── main.dart                  # Entry point
├── firebase_options.dart      
│
├── core/                      # App-wide configurations
│   ├── constants/
│   │   ├── app_colors.dart    # Change colors here for clients
│   │   ├── app_strings.dart   # App Name etc.
│   │   └── app_assets.dart    # Image paths
│   ├── theme/
│   │   └── app_theme.dart     # Light/Dark mode logic
│   └── utils/
│       ├── routes.dart        # Navigation routes
│       └── validators.dart    # Form validation logic
│
├── models/                    # Data Classes (Plain Dart Objects)
│   ├── product_model.dart
│   ├── user_model.dart
│   ├── cart_model.dart
│   └── order_model.dart
│
├── services/                  # Backend/API calls
│   ├── auth_service.dart      # Firebase Auth methods
│   ├── database_service.dart  # Firestore CRUD
│   └── storage_service.dart   # Image Uploads
│
├── view_models/               # State Management (Providers)
│   ├── auth_vm.dart
│   ├── product_vm.dart
│   ├── cart_vm.dart
│   └── admin_vm.dart
│
└── views/                     # UI Layer
├── shared/                # Reusable Widgets (Buttons, TextFields)
│   ├── custom_button.dart
│   ├── custom_textfield.dart
│   └── product_card.dart
│
├── user/                  # Customer App Screens
│   ├── auth/
│   │   ├── login_view.dart
│   │   └── register_view.dart
│   ├── home/
│   │   ├── home_view.dart
│   │   └── product_detail_view.dart
│   ├── cart/
│   │   └── cart_view.dart
│   └── profile/
│       └── order_history_view.dart
│
└── admin/                 # Admin Panel Screens (Web)
├── dashboard_view.dart
├── add_product_view.dart
└── orders_view.dart