import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'utils/theme.dart';
import 'services/auth_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize core services
  await initServices();

  runApp(const MyApp());
}

/// Initialize core services before app starts
Future<void> initServices() async {
  // Initialize AuthService as a singleton
  Get.put(AuthService(), permanent: true);
  
  print('✅ All services initialized');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CargoPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // GetX navigation setup
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      
      // Default transitions
      defaultTransition: Transition.cupertino,
      
      // Handle unknown routes
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      ),
    );
  }
}
