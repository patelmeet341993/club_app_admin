import 'package:club_app_admin/backend/authentication/authentication_provider.dart';
import 'package:club_model/backend/navigation/navigation_operation_parameters.dart';
import 'package:club_model/backend/navigation/navigation_type.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/configs/styles.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

import '../../../backend/club_backend/club_provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../configs/constants.dart';
import '../../common/components/common_popup.dart';
import '../../common/components/header_widget.dart';

class SystemScreenNavigator extends StatefulWidget {
  const SystemScreenNavigator({Key? key}) : super(key: key);

  @override
  _SystemScreenNavigatorState createState() => _SystemScreenNavigatorState();
}

class _SystemScreenNavigatorState extends State<SystemScreenNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.systemProfileNavigator,
      onGenerateRoute: NavigationController.onSystemProfileGeneratedRoutes,
    );
  }
}

class SystemMainScreen extends StatefulWidget {
  const SystemMainScreen({Key? key}) : super(key: key);

  @override
  State<SystemMainScreen> createState() => _SystemMainScreenState();
}

class _SystemMainScreenState extends State<SystemMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderWidget(
          title: "System Profile",
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            runSpacing: 20,
            spacing: 20,
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              getGoToPageButtons(
                  title: "Offers",
                  onTap: () {
                    NavigationController.navigateToOfferListScreen(
                        navigationOperationParameters: NavigationOperationParameters(
                      navigationType: NavigationType.pushNamed,
                      context: NavigationController.systemProfileNavigator.currentContext!,
                    ));
                  }),
              getGoToPageButtons(title: "Profile Details", onTap: () {}),
              getGoToPageButtons(title: "Home Page Banners", onTap: () {
                NavigationController.navigateToBannerListScreen(
                    navigationOperationParameters: NavigationOperationParameters(
                      navigationType: NavigationType.pushNamed,
                      context: NavigationController.systemProfileNavigator.currentContext!,
                    ));
              }),
              getGoToPageButtons(
                  title: "Logout",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CommonPopup(
                          text: "Logout",
                          content: "Are you sure you want to logout?",

                          rightText: "Yes",
                          rightOnTap: () async {
                            MyPrint.printOnConsole("context: ${context}");
                            AuthenticationProvider provider = Provider.of<AuthenticationProvider>(context,listen: false);
                            ClubProvider clubProvider = Provider.of<ClubProvider>(context,listen: false);
                            provider.setAdminUserModel(AdminUserModel());
                            clubProvider.clubList.setList(list: [ClubModel()]);

                            NavigationController.navigateToLoginScreen(
                              navigationOperationParameters: NavigationOperationParameters(
                                context: context,
                                navigationType: NavigationType.pushNamedAndRemoveUntil,
                              ),
                            );
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool(MySharePreferenceKeys.isLogin, false);
                            // if (context.mounted) {
                            //   Navigator.pop(context);
                            // }
                          },
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget getGoToPageButtons({required String title, Function()? onTap, String hintMessage = ''}) {
    return InkWell(
      onTap: onTap,
      child: Tooltip(
        message: hintMessage,
        child: Container(
          height: 100,
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Styles.yellow,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: CommonText(text: title, fontWeight: FontWeight.bold, fontSize: 22, color: Styles.bgSideMenu, textAlign: TextAlign.start)),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios, size: 18, color: Styles.bgSideMenu),
              )
            ],
          ),
        ),
      ),
    );
  }
}
