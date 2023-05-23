import 'package:club_app_admin/views/club/screens/add_club.dart';
import 'package:club_app_admin/views/club/screens/club_list_screen.dart';
import 'package:club_app_admin/views/users/screens/disabled_users_list.dart';
import 'package:club_app_admin/views/users/screens/user_list_screen.dart';
import 'package:club_model/backend/navigation/navigation_operation.dart';
import 'package:club_model/backend/navigation/navigation_operation_parameters.dart';
import 'package:club_model/utils/my_print.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../views/authentication/screens/login_screen.dart';
import '../../views/homescreen/screens/homescreen.dart';
import '../../views/product/screens/add_product.dart';
import '../../views/product/screens/product_list_screen.dart';
import '../../views/splash/splash_screen.dart';

class NavigationController {
  static NavigationController? _instance;
  static String chatRoomId = "";
  static bool isNoInternetScreenShown = false;
  static bool isFirst = true;

  factory NavigationController() {
    _instance ??= NavigationController._();
    return _instance!;
  }

  NavigationController._();

  static final GlobalKey<NavigatorState> mainScreenNavigator =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> productScreenNavigator =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> clubScreenNavigator =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> userScreenNavigator =
      GlobalKey<NavigatorState>();

  static bool isUserProfileTabInitialized = false;

  static bool checkDataAndNavigateToSplashScreen() {
    MyPrint.printOnConsole(
        "checkDataAndNavigateToSplashScreen called, isFirst:$isFirst");

    if (isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        isFirst = false;
        Navigator.pushNamedAndRemoveUntil(mainScreenNavigator.currentContext!,
            SplashScreen.routeName, (route) => false);
      });
    }

    return isFirst;
  }

  static Route? onMainAppGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole(
        "onAdminMainGeneratedRoutes called for ${settings.name} with arguments:${settings.arguments}");

    // if(navigationCount == 2 && Uri.base.hasFragment && Uri.base.fragment != "/") {
    //   return null;
    // }

    if (kIsWeb) {
      if (!["/", SplashScreen.routeName].contains(settings.name) &&
          NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    /*if(!["/", SplashScreen.routeName].contains(settings.name)) {
      if(NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    else {
      if(!kIsWeb) {
        if(isFirst) {
          isFirst = false;
        }
      }
    }*/

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/":
        {
          page = const SplashScreen();
          break;
        }
      case SplashScreen.routeName:
        {
          page = const SplashScreen();
          break;
        }
      case LoginScreen.routeName:
        {
          page = parseLoginScreen(settings: settings);
          break;
        }
      case HomeScreen.routeName:
        {
          page = parseHomeScreen(settings: settings);
          break;
        }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) =>
            SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
    return null;
  }

  static Route? onProductGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole(
        "Product Generated Routes called for ${settings.name} with arguments:${settings.arguments}");

    if (kIsWeb) {
      if (!["/", SplashScreen.routeName].contains(settings.name) &&
          NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/":
        {
          page = const ProductListScreen();
          break;
        }

      case AddProduct.routeName:
        {
          page = parseAddProductScreen(settings: settings);
          break;
        }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) =>
            SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
    return null;
  }

  static Route? onClubGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole(
        "Club Generated Routes called for ${settings.name} with arguments:${settings.arguments}");

    if (kIsWeb) {
      if (!["/", SplashScreen.routeName].contains(settings.name) &&
          NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/":
        {
          page = const ClubListScreen();
          break;
        }

      case AddClub.routeName:
        {
          page = parseAddClubScreen(settings: settings);
          break;
        }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) =>
            SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
    return null;
  }

  static Route? onUserGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole(
        "User Generated Routes called for ${settings.name} with arguments:${settings.arguments}");

    if (kIsWeb) {
      if (!["/", SplashScreen.routeName].contains(settings.name) &&
          NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/":
        {
          page = const UserListScreen();
          break;
        }

      case DisabledUsersList.routeName:
        {
          page = parseDisabledUsersScreen(settings: settings);
          break;
        }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) =>
            SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
    return null;
  }

  //region Parse Page From RouteSettings
  static Widget? parseLoginScreen({required RouteSettings settings}) {
    return const LoginScreen();
  }

  static Widget? parseHomeScreen({required RouteSettings settings}) {
    return HomeScreen();
  }

  static Widget? parseAddProductScreen({required RouteSettings settings}) {
    return AddProduct();
  }

  static Widget? parseAddClubScreen({required RouteSettings settings}) {
    return AddClub();
  }

  static Widget? parseDisabledUsersScreen({required RouteSettings settings}) {
    return DisabledUsersList();
  }
  //endregion

  static Future<dynamic> navigateToLoginScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: LoginScreen.routeName,
    ));
  }

  static Future<dynamic> navigateToHomeScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: HomeScreen.routeName,
    ));
  }

  static Future<dynamic> navigateToAddProductScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: AddProduct.routeName,
    ));
  }

  static Future<dynamic> navigateToAddClubScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: AddClub.routeName,
    ));
  }

  static Future<dynamic> navigateToDisabledUsersScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: DisabledUsersList.routeName,
    ));
  }
}
