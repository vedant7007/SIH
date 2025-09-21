import 'package:flutter/material.dart';
import '../presentation/project_detail_screen/project_detail_screen.dart';
import '../presentation/notification_center_screen/notification_center_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import '../presentation/interactive_map_screen/interactive_map_screen.dart';
import '../presentation/project_submission_screen/project_submission_screen.dart';
import '../presentation/carbon_credit_marketplace_screen/carbon_credit_marketplace_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/project_list_screen/project_list_screen.dart';
import '../presentation/camera_capture_screen/camera_capture_screen.dart';
import '../presentation/ngo_home_screen/ngo_home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String projectDetail = '/project-detail-screen';
  static const String notificationCenter = '/notification-center-screen';
  static const String profileSettings = '/profile-settings-screen';
  static const String splash = '/splash-screen';
  static const String adminDashboard = '/admin-dashboard-screen';
  static const String interactiveMap = '/interactive-map-screen';
  static const String projectSubmission = '/project-submission-screen';
  static const String carbonCreditMarketplace =
      '/carbon-credit-marketplace-screen';
  static const String authentication = '/authentication-screen';
  static const String projectList = '/project-list-screen';
  static const String cameraCapture = '/camera-capture-screen';
  static const String ngoHome = '/ngo-home-screen';
  static const String projectDetails = '/projectDetails';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    projectDetail: (context) => const ProjectDetailScreen(),
    notificationCenter: (context) => const NotificationCenterScreen(),
    profileSettings: (context) => const ProfileSettingsScreen(),
    splash: (context) => const SplashScreen(),
    adminDashboard: (context) => const AdminDashboardScreen(),
    interactiveMap: (context) => const InteractiveMapScreen(),
    projectSubmission: (context) => ProjectSubmissionScreen(),
    carbonCreditMarketplace: (context) => const CarbonCreditMarketplaceScreen(),
    authentication: (context) => const AuthenticationScreen(),
    projectList: (context) => ProjectListScreen(),
    cameraCapture: (context) => const CameraCaptureScreen(),
    ngoHome: (context) => const NgoHomeScreen(),
  };
}
