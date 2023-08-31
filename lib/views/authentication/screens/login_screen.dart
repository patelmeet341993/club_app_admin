import 'package:club_app_admin/backend/club_backend/club_controller.dart';
import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/backend/club_backend/club_repository.dart';
import 'package:club_model/backend/navigation/navigation_operation_parameters.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/utils/my_toast.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../backend/admin_user/admin_user_controller.dart';
import '../../../backend/admin_user/admin_user_repository.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../configs/constants.dart';
import '../../common/components/common_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  late AdminUserController adminController;
  late AuthenticationProvider adminProvider;
  late ClubController clubController;
  late ClubProvider clubProvider;
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> checkAdmin() async {
    AdminUserModel? adminModel = await AdminUserRepository().checkLoginAdminMethod(adminId: idController.text, password: passwordController.text.trim());
    if (adminModel == null) {
      ClubModel? clubModel = await ClubRepository().checkLoginClubMethod(adminId: idController.text, password: passwordController.text.trim());
      if (clubModel != null) {
        clubProvider.setClubModel(clubModel);
        if (context.mounted && context.checkMounted()) {
          MyToast.showSuccess(context: context, msg: "Logged In Successfully");
          NavigationController.navigateToHomeScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamedAndRemoveUntil,
            ),
          );
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(MySharePreferenceKeys.isLogin, true);
      } else {
        if (context.mounted && context.checkMounted()) {
          MyToast.showError(context: context, msg: "Please Enter Valid ID or Password");
        }
      }
    } else {
      adminProvider.setAdminUserModel(adminModel);
      if (context.mounted && context.checkMounted()) {
        MyToast.showSuccess(context: context, msg: "Logged In Successfully");
        NavigationController.navigateToHomeScreen(
            navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamedAndRemoveUntil,
        ));
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(MySharePreferenceKeys.isLogin, true);
      MyPrint.printOnConsole("SharedPreferences isLogin boolean set as ${prefs.getBool(MySharePreferenceKeys.isLogin)}");
    }
  }

  @override
  void initState() {
    super.initState();
    adminProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    clubProvider = context.read<ClubProvider>();
    adminController = AdminUserController(adminProvider: adminProvider);
    clubController = ClubController(clubProvider: clubProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgSideMenu,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width * .5,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: 'Login',
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Styles.white,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      CommonTextFormField(
                        controller: idController,
                        hintText: "Enter Your ID",
                        verticalPadding: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "  Please enter ID";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CommonTextFormField(
                        controller: passwordController,
                        hintText: "Password",
                        verticalPadding: 20,
                        obscureText: isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "  Please enter Password";
                          }
                          return null;
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.deny(" "),
                        ],
                        onFieldSubmitted: (val) async {
                          if (_formKey.currentState!.validate()) {
                            await checkAdmin();
                          }
                        },
                        suffixIcon: InkWell(
                            onTap: () {
                              isObscure = !isObscure;
                              setState(() {});
                            },
                            child: Icon(!isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Styles.bgSideMenu)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await checkAdmin();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              decoration: BoxDecoration(color: Styles.white, borderRadius: BorderRadius.circular(4)),
                              child: CommonText(
                                text: "Login",
                                color: Styles.bgSideMenu,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
