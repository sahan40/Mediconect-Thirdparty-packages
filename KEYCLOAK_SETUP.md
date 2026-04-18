# Keycloak Integration Setup Guide

## Overview
Your Flutter app is now integrated with Keycloak OAuth2/OIDC authentication. This guide will help you configure Keycloak for the app.

## Prerequisites
- Keycloak running on `http://localhost:8081` (Docker)
- Client ID: `OpenID`
- Realm: `master`

## Step 1: Configure Keycloak Client

### 1.1 Access Keycloak Admin Console
1. Open [http://localhost:8081/admin](http://localhost:8081/admin)
2. Login with admin credentials

### 1.2 Create or Update the "OpenID" Client
1. Go to Realm Settings → Select `master` realm
2. Click "Clients" in the left menu
3. Find or create client named `OpenID`:
   - **Client ID**: OpenID
   - **Client Protocol**: openid-connect
   - **Access Type**: Public (no secret needed)

### 1.3 Configure Client Settings
Click on the OpenID client and configure:

#### Valid Redirect URIs:
```
com.example.medi_connect:/oauth2callback
http://localhost:8081/auth/realms/master/app/oauth2callback
```

#### Web Origins:
```
*
```

#### Standard Flow Enabled: ON
#### Implicit Flow Enabled: OFF
#### Direct Access Grants Enabled: ON

### 1.4 Mapper Configuration
1. Go to the client and click "Mappers"
2. Ensure these mappers exist (should be default):
   - sub (subject)
   - email
   - name
   - preferred_username

## Step 2: Create Test User

1. Go to Users in left menu
2. Click "Add User"
3. **Username**: testuser
4. **Email**: testuser@example.com
5. **First Name**: Test
6. **Last Name**: User
7. Set Password (click "Set Password" in Credentials tab)
   - **Password**: testpass123
   - **Temporary**: OFF

## Step 3: Update Flutter App

### 3.1 Install Dependencies
```bash
cd medi_connect
flutter pub get
```

### 3.2 Configure Android Deep Linking
Already configured in `AndroidManifest.xml` with intent filter:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data
        android:scheme="com.example.medi_connect"
        android:host="oauth2callback"/>
</intent-filter>
```

### 3.3 Configure iOS (if testing on iOS)

Open `ios/Runner/Info.plist` and add:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>com.example.medi_connect</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.example.medi_connect</string>
    </array>
  </dict>
</array>
```

## Step 4: Test the Integration

### 4.1 Run the App
```bash
flutter run
```

### 4.2 Test Keycloak Login
1. On the login screen, tap "Login with Keycloak"
2. Browser will open Keycloak login page
3. Enter credentials:
   - **Email/Username**: testuser
   - **Password**: testpass123
4. Grant permissions if prompted
5. App should redirect back and show dashboard

## Step 5: Verify Configuration

### 5.1 Test Token Storage
The app stores tokens in secure storage:
- Access token (used for API calls)
- Refresh token (used to refresh access token)
- ID token (contains user info)

### 5.2 API Integration (Future)
When connecting to backend APIs:
```dart
final accessToken = await _datasource.getAccessToken();
// Use in Authorization header:
headers: {'Authorization': 'Bearer $accessToken'}
```

## Troubleshooting

### Issue: "Keycloak URL not reachable"
- Ensure Keycloak Docker container is running
- Check Docker logs: `docker logs keycloak-container-name`
- Verify URL: `http://localhost:8081`

### Issue: OAuth callback not working
- Verify redirect URI in Keycloak matches exactly: `com.example.medi_connect:/oauth2callback`
- Check Android intent filter is properly formatted
- Test on actual device (emulator may have issues with custom schemes)

### Issue: "Token expired" errors during development
- Token refresh is automatic via `refreshAccessToken()` method
- Check token expiration time in Keycloak realm settings
- Default: 5 minutes

### Issue: User info not loading
- Verify mappers are configured in Keycloak client
- Check JWT token claims: Use jwt.io to decode token
- Ensure email is set for user in Keycloak

## Files Modified

1. **pubspec.yaml** - Added flutter_appauth and jwt_decoder
2. **AndroidManifest.xml** - Added OAuth redirect intent filter + INTERNET permission
3. **lib/data/datasources/keycloak_auth_datasource.dart** - NEW: Keycloak OAuth datasource
4. **lib/data/repositories/keycloak_auth_repository.dart** - NEW: Keycloak auth repository
5. **lib/presentation/state/login_state.dart** - Added `loginWithKeycloak()` method
6. **lib/presentation/screens/login_screen.dart** - Added Keycloak login button in UI

## Architecture

```
LoginScreen
    ↓
LoginState.loginWithKeycloak()
    ↓
KeycloakAuthRepository.performOAuth2Login()
    ↓
KeycloakAuthDatasource.authenticate()
    ↓
FlutterAppAuth (Opens browser)
    ↓
Keycloak
    ↓
Returns token + user info
    ↓
Store in FlutterSecureStorage
    ↓
Return UserModel to UI
```

## Next Steps

1. Test OAuth2 flow with your Keycloak instance
2. Configure signup integration (if needed - currently uses Keycloak self-registration)
3. Add automatic token refresh handling
4. Integrate Keycloak logout in profile screen
5. Add API authentication with access tokens
6. Test password reset flow with Keycloak

## Support

For more information:
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [flutter_appauth](https://pub.dev/packages/flutter_appauth)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
