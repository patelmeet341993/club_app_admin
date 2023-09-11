import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/models/common/data_model/banner_model.dart';
import 'package:flutter/material.dart';

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
          HeaderWidget(title: 'Home Page Banners',isBackArrow: true,),
          Expanded(child: getListView()),


        ],
      ),
    );
  }

  Widget getListView(){
    return ReorderableListView.builder(
        itemBuilder: (context,index){
          return Container();
        },
        itemCount: 5,
        onReorder: reorderData);
  }

  Widget getContainer(Color color){
    return Container(
       key: ValueKey(1),
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