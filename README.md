# MediConnect - Hospital Management App

MediConnect is a Flutter-based mobile application for hospital management. It supports patient registration, appointment workflows, and access to medical records. The app integrates with a FHIR (Fast Healthcare Interoperability Resources) backend to enable standardized healthcare data exchange.

This project is part of a research effort focused on evaluating security and performance when building Flutter apps using official ecosystem packages.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Research Context](#research-context)

## Overview

The app is designed to support common healthcare workflows:

- Patient onboarding and profile management
- Appointment booking and schedule tracking
- Doctor profile and availability browsing
- Medical record and consultation history viewing
- Secure API-based communication with backend services

## Key Features

### Patient Management

- Register new patients
- View and update patient profiles
- Store demographic and contact information

### Appointment Scheduling

- Book appointments with doctors
- View upcoming and past appointments
- Reschedule or cancel appointments

### Doctor Information

- View doctor profiles
- Access specialization and department details
- Check consultation availability

### Medical Records Viewer

- View consultation history
- Display observations and encounter details
- Access prescription information

### Notifications and Reminders

- Appointment reminders
- Health record update notifications

### Secure Data Access

- Authentication for authorized users
- Secure communication with backend APIs

## System Architecture

MediConnect follows a layered architecture:

1. **Frontend Layer**  
	Flutter mobile client for UI and app-side logic.
2. **Integration Layer**  
	RESTful API communication using FHIR-aligned resources.
3. **Backend Layer**  
	HAPI FHIR server for healthcare resource management.
4. **Data Layer**  
	PostgreSQL storage for structured FHIR-compliant data.

## Technology Stack

The application uses official Flutter ecosystem packages where possible for long-term support, security, and maintainability.

| Feature | Package |
|---|---|
| State management | `provider` (with `ChangeNotifier`) |
| API communication | `dio` |
| Navigation | `auto_route` |
| Local storage | `hive` |
| Notifications | `flutter_local_notifications` |

### Package Integration Notes

- State management is provided through `ChangeNotifierProvider` wrappers in `presentation/state`.
- Networking clients were migrated to `dio` for request configuration and error handling.
- Routing uses `auto_route` with `RootStackRouter.build` and path-based navigation.
- App key-value persistence is handled through a Hive box (`app_kv`) in `LocalDatabase`.
- Local notification bootstrapping is centralized in `NotificationService` and initialized from `main.dart`.

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio or VS Code with Flutter tooling
- A running backend FHIR server (if testing live integration)

### Installation

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### Build Commands

```bash
# Android APK
flutter build apk

# iOS (macOS only)
flutter build ios

# Web
flutter build web
```

## Project Structure

```text
lib/
  core/          # App-wide constants, theme, routes, shared styling
  data/          # Datasources and repository implementations
  domain/        # Domain models and services
  presentation/  # Screens, state management, and UI widgets
  main.dart      # Application entry point
```

## Research Context

This codebase supports a research study comparing official and third-party Flutter plugin usage, with an emphasis on:

- Security exposure
- Performance impact
- Maintainability and long-term stability

## FHIR Integration Environment Setup

Use these steps to prepare local development for FHIR server integration.

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Run app with FHIR configuration

```bash
flutter run \
  --dart-define=FHIR_BASE_URL=https://your-fhir-server/fhir \
  --dart-define=FHIR_AUTH_BASE_URL=https://your-auth-server \
  --dart-define=FHIR_CLIENT_ID=medi-connect-mobile \
  --dart-define=FHIR_REDIRECT_URI=com.medi.connect://oauth-callback \
  --dart-define=FHIR_SCOPE="openid profile offline_access patient/*.read" \
  --dart-define=FHIR_USE_HTTPS=true
```

### 3. Verify environment keys

`FhirEnvironment` in `lib/core/config/fhir_environment.dart` exposes:

- `isConfigured`
- `missingKeys`

Use these before enabling production authentication logic.

### 4. Available FHIR scaffolding

- `lib/core/network/fhir_http_client.dart`
- `lib/data/datasources/auth_secure_token_datasource.dart`
- `lib/data/datasources/fhir/fhir_metadata_remote_datasource.dart`
- `lib/data/datasources/fhir/fhir_patient_remote_datasource.dart`

### 5. New package migration summary

- Removed: `go_router`, `http`, `path_provider`, `sqflite`
- Added: `provider`, `dio`, `hive`, `auto_route`, `flutter_local_notifications`

### 6. Next milestone

Implement SMART on FHIR OAuth2 PKCE login and inject the resulting access token
into `FhirHttpClient`.