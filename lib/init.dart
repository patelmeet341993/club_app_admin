import 'dart:async';
import 'dart:io';

import 'package:club_model/club_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'configs/credentials.dart';
import 'views/myapp.dart';

/// Runs the app in [runZonedGuarded] to handle all types of errors, including [FlutterError]s.
/// Any error that is caught will be send to Sentry backend
Future<void>? runErrorSafeApp({bool isDev = false}) {
  return runZonedGuarded<Future<void>>(
    () async {
      await initApp(isDev: isDev);
      runApp(
        const MyApp(),
      );
    },
    (e, s) {
      MyPrint.printOnConsole("Error in runZonedGuarded:$e");
      MyPrint.printOnConsole(s);
      // AnalyticsController().recordError(e, stackTrace);
    },
  );
}

/// It provides initial initialisation the app and its global services
Future<void> initApp({bool isDev = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppController.isDev = isDev;

  List<Future> futures = [];

  usePathUrlStrategy();

  if (kIsWeb) {
    FirebaseOptions options = getFirebaseOptions(isDev: isDev);
    MyPrint.printOnConsole(options);

    futures.addAll([
      Firebase.initializeApp(
        options: options,
      ),
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
      ]),
    ]);
  } else {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      HttpOverrides.global = MyHttpOverrides();
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      futures.addAll([
        Firebase.initializeApp(),
        SystemChrome.setPreferredOrientations(<DeviceOrientation>[
          DeviceOrientation.portraitUp,
        ]),
      ]);
    }
  }

  await Future.wait(futures);

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
    try {
      await Future.wait([
        FirebaseMessaging.instance.requestPermission(),
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        ),
      ]);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Requesting Notifications Permission:$e");
      MyPrint.printOnConsole(s);
    }
  }
  MyPrint.printOnConsole('Running ${isDev ? 'dev' : 'prod'} version...');
}
