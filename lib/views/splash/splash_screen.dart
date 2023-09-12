import 'package:club_app_admin/backend/admin/admin_controller.dart';
import 'package:club_app_admin/backend/admin/admin_provider.dart';
import 'package:club_app_admin/backend/brands_backend/brand_controller.dart';
import 'package:club_app_admin/backend/brands_backend/brand_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../backend/authentication/authentication_controller.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirst = true;

  late MyAdminController adminController;
  late BrandController brandController;
  late BrandProvider brandProvider;
  late MyAdminProvider adminProvider;

  void loginCheckMethod(BuildContext context) async {
    NavigationController.isFirst = false;
    await getAppRelatedData();

    await Future.delayed(const Duration(milliseconds: 600));
    MyPrint.printOnConsole("In loginCheckMethod");
    bool userLoggedIn =
        await AuthenticationController().checkUserLoginForFirstTime();

    if (userLoggedIn) {
      MyPrint.printOnConsole("User logged in");
      if (context.mounted) {
        NavigationController.navigateToHomeScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamedAndRemoveUntil,
          ),
        );
      }
    } else {
      MyPrint.printOnConsole("user not logged in");
      if (context.mounted) {
        NavigationController.navigateToLoginScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamedAndRemoveUntil,
          ),
        );
      }
    }
  }

  Future<void> getAppRelatedData() async {
    DateTime start = DateTime.now();
    MyPrint.printOnConsole("getAppRelatedData called");

    await Future.wait([
      adminController.getPropertyDataAndSetInProvider(),
      brandController.getBrandList()
    ]);

    DateTime end = DateTime.now();
    MyPrint.printOnConsole(
        "getAppRelatedData finished in ${start.difference(end).inMilliseconds} Milliseconds");
  }

  @override
  void initState() {
    super.initState();
    adminProvider = Provider.of<MyAdminProvider>(context, listen: false);
    adminController = MyAdminController(adminProvider: adminProvider);
    brandProvider = context.read<BrandProvider>();
    brandController = BrandController(brandProvider: brandProvider);


  }

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      isFirst = false;
      loginCheckMethod(context);
    }

    return Scaffold(
      backgroundColor: Styles.bgSideMenu,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonText(
                text: "CLUB",
                textAlign: TextAlign.center,
                color: Styles.yellow,
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
