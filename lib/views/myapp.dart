import 'package:club_app_admin/backend/admin/admin_provider.dart';
import 'package:club_app_admin/backend/authentication/authentication_provider.dart';
import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/backend/club_operator_backend/club_operator_provider.dart';
import 'package:club_app_admin/backend/common/menu_provider.dart';
import 'package:club_app_admin/backend/products_backend/product_provider.dart';
import 'package:club_app_admin/backend/users_backend/user_provider.dart';
import 'package:club_model/backend/admin/admin_provider.dart';
import 'package:club_model/backend/notification/notification_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:flutter/material.dart';

import '../backend/brands_backend/brand_provider.dart';
import '../backend/navigation/navigation_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("MyApp Build Called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppThemeProvider>(
            create: (_) => AppThemeProvider(), lazy: false),
        ChangeNotifierProvider<AdminProvider>(
            create: (_) => AdminProvider(), lazy: false),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(), lazy: false),
        ChangeNotifierProvider<MenuProvider>(
            create: (_) => MenuProvider(), lazy: false),
        ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider(), lazy: false),
        ChangeNotifierProvider<ClubProvider>(
            create: (_) => ClubProvider(), lazy: false),
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(), lazy: false),
        ChangeNotifierProvider<BrandProvider>(
            create: (_) => BrandProvider(), lazy: false),
        ChangeNotifierProvider<MyAdminProvider>(
            create: (_) => MyAdminProvider(), lazy: false),
        ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider(), lazy: false),
        ChangeNotifierProvider<ClubOperatorProvider>(
            create: (_) => ClubOperatorProvider(), lazy: false),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("MainApp Build Called");

    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appThemeProvider,
          Widget? child) {
        //MyPrint.printOnConsole("ThemeMode:${appThemeProvider.themeMode}");

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationController.mainScreenNavigator,
          title: "Admin",
          theme: appThemeProvider.getThemeData(),
          onGenerateRoute: NavigationController.onMainAppGeneratedRoutes,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
          ],
        );
      },
    );
  }
}
