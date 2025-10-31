import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Core Services
import 'core/services/storage_service.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';

// Core Controllers
import 'features/auth/auth_controller.dart';

// Core Constants
import 'core/constants/colors.dart';
import 'core/constants/app_constants.dart';

// Features
import 'features/auth/login_page.dart';
import 'features/dashboard/dashboard_page.dart';

// Widgets
import 'widgets/app_sidebar.dart';
import 'widgets/app_topbar.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.init();

  // Run the app
  runApp(NaseejAdminApp());
}

class NaseejAdminApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  NaseejAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _getThemeMode(),
      initialRoute: '/',
      getPages: _getAppRoutes(),
      home: FutureBuilder(
        future: _checkInitialAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSplashScreen();
          }
          // FIXED: Use GetBuilder instead of Obx for simple state
          return GetBuilder<AuthController>(
            builder: (authController) {
              return authController.isLoggedIn ? MainLayout() : LoginPage();
            },
          );
        },
      ),
      defaultTransition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
      locale: _getLocale(),
      fallbackLocale: Locale('en', 'US'),
      enableLog: true,
      logWriterCallback: _logWriter,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }

  Widget _buildMainContent() {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return authController.isLoggedIn ? MainLayout() : LoginPage();
      },
    );
  }

  Future<bool> _checkInitialAuth() async {
    // Check if user is already logged in
    await Future.delayed(Duration(milliseconds: 500));
    return authController.isLoggedIn; // This now uses the simple getter
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.secondary,
      primaryColorDark: AppColors.tertiary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBg,
        background: AppColors.background,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.cardBg,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontFamily: 'PlayfairDisplay',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontFamily: 'PlayfairDisplay',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontFamily: 'PlayfairDisplay',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGray,
          fontFamily: 'Cairo',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
          fontFamily: 'Cairo',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
          fontFamily: 'Cairo',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.darkGray,
          fontFamily: 'Cairo',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.darkGray,
          fontFamily: 'Cairo',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.gray,
          fontFamily: 'Cairo',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: TextStyle(
          color: AppColors.gray,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppColors.gray,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),
      useMaterial3: false,
      fontFamily: 'Cairo',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.secondary,
      primaryColorDark: AppColors.tertiary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkSurface,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'PlayfairDisplay',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'PlayfairDisplay',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'PlayfairDisplay',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Cairo',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Cairo',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Cairo',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white70,
          fontFamily: 'Cairo',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white70,
          fontFamily: 'Cairo',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.white60,
          fontFamily: 'Cairo',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: TextStyle(
          color: Colors.white60,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: Colors.white60,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),
      useMaterial3: false,
      fontFamily: 'Cairo',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  ThemeMode _getThemeMode() {
    final themeMode = StorageService.getThemeMode();
    switch (themeMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Locale? _getLocale() {
    final language = StorageService.getLanguage();
    switch (language) {
      case 'en':
        return Locale('en', 'US');
      case 'ar':
        return Locale('ar', 'SA');
      default:
        return null;
    }
  }

  List<GetPage> _getAppRoutes() {
    return [
      GetPage(name: '/', page: () => MainLayout()),
      GetPage(name: '/login', page: () => LoginPage()),
      GetPage(name: '/dashboard', page: () => DashboardPage()),
    ];
  }

  void _logWriter(String text, {bool isError = false}) {
    if (isError) {
      print('❌ $text');
    } else {
      print('📱 $text');
    }
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.home,
                size: 60,
                color: AppColors.primary,
              ),
            )
                .animate()
                .scale(duration: 800.ms)
                .then(delay: 200.ms)
                .shake(duration: 600.ms),
            SizedBox(height: 32),
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'PlayfairDisplay',
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            SizedBox(height: 8),
            Text(
              'Handmade Carpets Admin Panel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'Cairo',
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms),
            SizedBox(height: 48),
            Container(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 1500.ms),
          ],
        ),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AppSidebar(
            currentRoute: Get.currentRoute,
          ),
          Expanded(
            child: Column(
              children: [
                AppTopbar(
                  title: _getPageTitle(Get.currentRoute),
                  showBackButton: Get.currentRoute != '/dashboard',
                ),
                Expanded(
                  child: GetRouterOutlet(
                    initialRoute: '/dashboard',
                    anchorRoute: '/',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(String route) {
    switch (route) {
      case '/dashboard':
        return 'Dashboard';
      case '/products':
        return 'Products Management';
      case '/products/add':
        return 'Add New Product';
      case var route when route.startsWith('/products/edit'):
        return 'Edit Product';
      case '/categories':
        return 'Categories Management';
      case '/categories/add':
        return 'Add New Category';
      case '/orders':
        return 'Orders Management';
      case var route when route.startsWith('/orders/details'):
        return 'Order Details';
      case '/customers':
        return 'Customers Management';
      case var route when route.startsWith('/customers/details'):
        return 'Customer Details';
      case '/delivery':
        return 'Delivery Men Management';
      case '/delivery/add':
        return 'Add Delivery Man';
      case '/stores':
        return 'Stores Management';
      case '/stores/add':
        return 'Add New Store';
      case '/settings':
        return 'Settings';
      case '/profile':
        return 'My Profile';
      default:
        return 'Naseej Admin';
    }
  }
}