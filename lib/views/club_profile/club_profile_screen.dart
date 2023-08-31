import 'package:club_app_admin/views/common/components/common_text_form_field.dart';
import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../backend/navigation/navigation_controller.dart';

class ClubProfileScreenNavigator extends StatefulWidget {
  const ClubProfileScreenNavigator({Key? key}) : super(key: key);

  @override
  _ClubProfileScreenNavigatorState createState() => _ClubProfileScreenNavigatorState();
}

class _ClubProfileScreenNavigatorState extends State<ClubProfileScreenNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.clubProfileNavigator,
      onGenerateRoute: NavigationController.onClubProfileGeneratedRoutes,
    );
  }
}

class ClubProfileScreen extends StatefulWidget {
  const ClubProfileScreen({Key? key}) : super(key: key);

  @override
  State<ClubProfileScreen> createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  bool isOpen = false;

  TextEditingController aboutController  = TextEditingController();
  TextEditingController nameController  = TextEditingController();
  TextEditingController rulesController  = TextEditingController();
  TextEditingController termsController  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(title: "Club Profile", suffixWidget: getClubOpenCloseSwitch()),
          SizedBox(height: 30,),
          nameWidget(),
          SizedBox(height: 20,),
          about(),
          SizedBox(height: 20,),
          rulesWidget(),
          SizedBox(height: 20,),
          termsWidget()

        ],
      ),
    );
  }

  Widget getClubOpenCloseSwitch() {
    return Container(
      child: CupertinoSwitch(
        value: isOpen,
        activeColor: Styles.bgSideMenu,
        onChanged: (bool isValue) {
          isOpen = isValue;
          setState(() {});
        },
      ),
    );
  }

  Widget about(){
    return getCommonWithHeader(
      headerText: "About",
      widget: CommonTextFormField(
        hintText: "About",
        minLines: 4,
        maxLines: 4,
        controller: aboutController,
      ),
    );
  }

  Widget nameWidget(){
    return getCommonWithHeader(
      headerText: "Name",
      widget: CommonTextFormField(
        hintText: "Name",
        controller: nameController,
      ),
    );
  }

  Widget rulesWidget(){
    return getCommonWithHeader(
      headerText: "Rules",
      widget: CommonTextFormField(
        hintText: "Rules",
        controller: rulesController,
      ),
    );
  }

  Widget termsWidget(){
    return getCommonWithHeader(
      headerText: "Terms & Condition",
      widget: CommonTextFormField(
        hintText: "Terms & Condition",
        controller: termsController,
      ),
    );
  }

  Widget getCommonWithHeader({String headerText = "", Widget? widget}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(text: headerText,fontSize: 18, fontWeight: FontWeight.w600,),
        SizedBox(height: 10,),
        widget ?? SizedBox()
      ],
    );
  }
}
