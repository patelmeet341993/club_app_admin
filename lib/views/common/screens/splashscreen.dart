import 'dart:math';

import 'package:club_model/club_model.dart';
import 'package:flutter/material.dart';

import '../../../backend/navigation/navigation_controller.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ThemeData themeData;

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 600));

    NavigationController.isFirst = false;
    if (context.mounted) {
      if (Random().nextBool()) {
        NavigationController.navigateToHomeScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamedAndRemoveUntil,
          ),
        );
      } else {
        NavigationController.navigateToLoginScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamedAndRemoveUntil,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      color: themeData.colorScheme.background,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              /*Center(
                child: LoadingAnimationWidget.inkDrop(color: themeData.backgroundColor, size: 40),
              ),*/
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5)),
                      child: Icon(Icons.vaccines, color: themeData.primaryColor, size: 80),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Hospital Management System",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Center(
                child: LoadingAnimationWidget.inkDrop(color: themeData.primaryColor, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
