# TODO List for App Modifications

## 1. Replace Authority Dashboard with User Dashboard
- [ ] Update main_screen.dart to use UserDashboardScreen instead of DashboardScreen in the bottom navigation.

## 2. Fetch Actual User Data in User Dashboard
- [ ] Modify user_dashboard_screen.dart to fetch real user data from backend using AuthService.getUser().
- [ ] Replace static data with dynamic data fetched from backend.

## 3. Make Home Screen Map Zoomable
- [ ] Update home_screen.dart to wrap the map image in InteractiveViewer for zoom in/out functionality.

## 4. Change App Name
- [ ] Update pubspec.yaml to change app name from "crowd_app" to "TransitAI".
