import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'providers/emotion_provider.dart';
import 'providers/auth_provider.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/emotion/emotion_tracking_screen.dart';
import 'screens/analytics/analytics_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utils/app_theme.dart';
import 'utils/routes.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser la base de données
  await DatabaseService().initDatabase();
  
  // Initialiser les notifications
  await NotificationService().initNotifications();
  
  runApp(const FeelomiApp());
}

class FeelomiApp extends StatelessWidget {
  const FeelomiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
      ],
      child: MaterialApp(
        title: 'FEELOMI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (context) => const SplashScreen(),
          Routes.login: (context) => const LoginScreen(),
          Routes.home: (context) => const HomeScreen(),
          Routes.emotionTracking: (context) => const EmotionTrackingScreen(),
          Routes.analytics: (context) => const AnalyticsScreen(),
          Routes.profile: (context) => const ProfileScreen(),
        },
      ),
    );
  }
}