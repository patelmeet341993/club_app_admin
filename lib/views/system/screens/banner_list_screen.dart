import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/backend/navigation/navigation_operation_parameters.dart';
import 'package:club_model/backend/navigation/navigation_type.dart';
import 'package:club_model/configs/styles.dart';
import 'package:club_model/models/common/data_model/banner_model.dart';
import 'package:flutter/material.dart';

import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';

class BannerListScreen extends StatefulWidget {
  static const String routeName = "/BannerListScreen";
  const BannerListScreen({Key? key}) : super(key: key);

  @override
  State<BannerListScreen> createState() => _BannerListScreenState();
}

class _BannerListScreenState extends State<BannerListScreen> {

  List<BannerModel> bannerList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(title: 'Home Page Banners',isBackArrow: true,
          suffixWidget: CommonButton(
              text: "Add Banner",
              icon: Icon(
                Icons.add,
                color: Styles.white,
              ),
              onTap: () {
                NavigationController.navigateToAddBannerScreen(
                    navigationOperationParameters: NavigationOperationParameters(
                      navigationType: NavigationType.pushNamed,
                      context: NavigationController.systemProfileNavigator.currentContext!,
                    ));

              }),
          ),
          Expanded(child: getListView()),


        ],
      ),
    );
  }

  Widget getListView(){
    return ReorderableListView.builder(
        itemBuilder: (context,index){
          return getContainer(Colors.redAccent,index);
        },
        itemCount: 5,
        onReorder: reorderData);
  }

  Widget getContainer(Color color,int index){
    return Container(
      margin: EdgeInsets.all(10),
      key: ValueKey(index),
      height: 50,
      width: double.maxFinite,
      color:color,
    );
  }

  void reorderData(int oldindex, int newindex){
    setState(() {
      if(newindex>oldindex){
        newindex-=1;
      }
    });
  }



}



