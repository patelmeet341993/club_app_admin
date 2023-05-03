import 'package:club_app_admin/backend/navigation/navigation_controller.dart';
import 'package:club_model/club_model.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with MySafeState {
  late ThemeData themeData;
  bool isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(String userName, String password) async {
    isLoading = true;
    mySetState();

    await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = true;
    MyPrint.printOnConsole("isLoggedIn:$isLoggedIn");

    isLoading = false;
    mySetState();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return Consumer<AppThemeProvider>(builder: (context, AppThemeProvider appThemeProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const LoadingWidget(),
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Center(
            child: Container(
              child: mainBody(),
            ),
          ),
        ),
      );
    });
  }

  Widget mainBody() {
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Login Screen"),
          ElevatedButton(
            onPressed: () {
              NavigationController.navigateToHomeScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamedAndRemoveUntil,
                ),
              );
            },
            child: const Text("Home SCreen"),
          )
        ],
      ),
    );
  }

  Widget getEmailTextField() {
    return TextFormField(
      controller: usernameController,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      cursorHeight: 25,
      decoration: InputDecoration(
        hintText: "Enter Username",
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        filled: true,
        fillColor: themeData.colorScheme.background,
        prefixIcon: Icon(
          Icons.person,
          size: 22,
          color: themeData.colorScheme.onBackground.withAlpha(200),
        ),
        prefixIconColor: themeData.primaryColor,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      validator: (text) {
        if (text?.isNotEmpty ?? false) {
          return null;
        } else {
          return "UserId is Required";
        }
      },
    );
  }

  Widget getPasswordTextField() {
    return TextFormField(
      controller: passwordController,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      cursorHeight: 25,
      onFieldSubmitted: (val) {
        if (_globalKey.currentState?.validate() ?? false) {
          login(usernameController.text, passwordController.text);
        }
      },
      decoration: InputDecoration(
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        filled: true,
        fillColor: themeData.colorScheme.background,
        prefixIcon: Icon(
          Icons.lock,
          size: 22,
          color: themeData.colorScheme.onBackground.withAlpha(200),
        ),
        prefixIconColor: themeData.primaryColor,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      validator: (text) {
        if (text?.isNotEmpty ?? false) {
          return null;
        } else {
          return "Password is Required";
        }
      },
    );
  }
}
