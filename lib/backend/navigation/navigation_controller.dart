import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_app_admin/views/brand/screens/add_brand_screen.dart';
import 'package:club_app_admin/views/brand/screens/brand_list_screen.dart';
import 'package:club_app_admin/views/club/screens/add_club.dart';
import 'package:club_app_admin/views/club/screens/club_list_screen.dart';
import 'package:club_app_admin/views/club/screens/club_user_list.dart';
import 'package:club_app_admin/views/system/componants/add_banner_screen.dart';
import 'package:club_app_admin/views/system/screens/banner_list_screen.dart';
import 'package:club_app_admin/views/system/screens/system_main_screen.dart';
import 'package:club_app_admin/views/users/screens/disabled_users_list.dart';
import 'package:club_app_admin/views/users/screens/user_list_screen.dart';
import 'package:club_app_admin/views/club_profile/club_profile_screen.dart';
import 'package:club_model/backend/navigation/navigation_operation.dart';
import 'package:club_model/backend/navigation/navigation_operation_parameters.dart';
import 'package:club_model/utils/my_print.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../views/authentication/screens/login_screen.dart';
import '../../views/club/screens/add_club_user.dart';
import '../../views/homescreen/screens/homescreen.dart';
import '../../views/notifications/screens/add_notification_screen.dart';
import '../../views/notifications/screens/notification_list_screen.dart';
import '../../views/product/screens/add_product.dart';
import '../../views/product/screens/product_list_screen.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/system/screens/offer_list_screen.dart';
import 'navigation_arguments.dart';

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
  static final GlobalKey<NavigatorState> systemProfileNavigator =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> brandScreenNavigator =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> clubProfileNavigator =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> clubUserNavigator =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> notificatioScreenNavigator =
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

  static Route? onBrandGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole(
        "Brand Routes called for ${settings.name} with arguments:${settings.arguments}");

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
          page = const BrandListScreen();
          break;
        }

      case AddBrand.routeName:
        {
          page = parseAddBrandScreen(settings: settings);
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

  static Route? onNotificationGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole(
        "Notification Routes called for ${settings.name} with arguments:${settings.arguments}");

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
          page = const NotificationListScreen();
          break;
        }

      case AddNotificationScreen.routeName:
        {
          page = parseAddNotificationScreen(settings: settings);
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

  static Route? onSystemProfileGeneratedRoutes(RouteSettings settings) {
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
          page = const SystemMainScreen();
          break;
        }

      case OfferListScreen.routeName:
        {
          page = parseOffersListScreen(settings: settings);
          break;
        }
        case LoginScreen.routeName:
        {
          page = parseLoginScreen(settings: settings);
          break;
        }
        case BannerListScreen.routeName:
        {
          page = parseBannerListScreen(settings: settings);
          break;
        }

        case AddBannerScreen.routeName:
        {
          page = parseAddBannerScreen(settings: settings);
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

  static Route? onClubProfileGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole("Club Generated Routes called for ${settings.name} with arguments:${settings.arguments}");

    if (kIsWeb) {
      if (!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/":
        {
          page = const ClubProfileScreen();
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
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
    return null;
  }

  static Route? onClubUserGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole("Club Generated Routes called for ${settings.name} with arguments:${settings.arguments}");

    if (kIsWeb) {
      if (!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/":
        {
          page = const ClubUserListScreen();
          break;
        }

      case AddClubUser.routeName:
        {
          page = parseAddClubUserScreen(settings: settings);
          break;
        }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //new commit
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
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

  static Widget? parseDisabledUsersScreen({required RouteSettings settings}) {
    return DisabledUsersList();
  }

  static Widget? parseOffersListScreen({required RouteSettings settings}) {
    return OfferListScreen();
  }

  static Widget? parseBannerListScreen({required RouteSettings settings}) {
    return BannerListScreen();
  }

  static Widget? parseAddProductScreen({required RouteSettings settings}) {
    if (settings.arguments is AddEditProductNavigationArgument) {
      AddEditProductNavigationArgument arguments =
      settings.arguments as AddEditProductNavigationArgument;
      return AddProduct(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseAddBrandScreen({required RouteSettings settings}) {
    if (settings.arguments is AddBrandScreenNavigationArguments) {
      AddBrandScreenNavigationArguments arguments =
      settings.arguments as AddBrandScreenNavigationArguments;
      return AddBrand(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseAddNotificationScreen({required RouteSettings settings}) {
  return AddNotificationScreen();
  }

  static Widget? parseAddClubScreen({required RouteSettings settings}) {
    return AddClub();
  }

  static Widget? parseAddClubUserScreen({required RouteSettings settings}) {
    return const AddClubUser();
  }

  static Widget? parseAddBannerScreen({required RouteSettings settings}) {
    if (settings.arguments is AddBannerScreenNavigationArguments) {
      AddBannerScreenNavigationArguments arguments =
      settings.arguments as AddBannerScreenNavigationArguments;
      return AddBannerScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
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
      {required NavigationOperationParameters navigationOperationParameters,required AddEditProductNavigationArgument addProductScreenNavigationArguments}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: AddProduct.routeName,
          arguments: addProductScreenNavigationArguments,
    ));
  }

  static Future<dynamic> navigateToAddBrandScreen(
      {required NavigationOperationParameters navigationOperationParameters,required AddBrandScreenNavigationArguments addBrandScreenNavigationArguments}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: AddBrand.routeName,
          arguments: addBrandScreenNavigationArguments,
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

  static Future<dynamic> navigateToOfferListScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: OfferListScreen.routeName,
    ));
  }

  static Future<dynamic> navigateToBannerListScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: BannerListScreen.routeName,
    ));
  }

  static Future<dynamic> navigateToAddClubUserScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
          routeName: AddClubUser.routeName,
        ));
  }

  static Future<dynamic> navigateToAddNotificationScreen(
      {required NavigationOperationParameters navigationOperationParameters}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
          routeName: AddNotificationScreen.routeName,
        ));
  }

  static Future<dynamic> navigateToAddBannerScreen(
      {required NavigationOperationParameters navigationOperationParameters,required AddBannerScreenNavigationArguments addBannerScreenNavigationArguments}) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
          routeName: AddBannerScreen.routeName,
          arguments: addBannerScreenNavigationArguments
        ));
  }
}
