import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/backend/admin/admin_controller.dart';
import 'package:club_model/backend/admin/admin_provider.dart';
import 'package:club_model/backend/navigation/navigation_operation_parameters.dart';
import 'package:club_model/backend/navigation/navigation_type.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/configs/styles.dart';
import 'package:club_model/models/common/data_model/banner_model.dart';
import 'package:club_model/view/common/components/common_cachednetwork_image.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:club_model/view/common/components/loading_widget.dart';
import 'package:club_model/view/common/components/modal_progress_hud.dart';
import 'package:flutter/material.dart';

import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_popup.dart';

class BannerListScreen extends StatefulWidget {
  static const String routeName = "/BannerListScreen";
  const BannerListScreen({Key? key}) : super(key: key);

  @override
  State<BannerListScreen> createState() => _BannerListScreenState();
}

class _BannerListScreenState extends State<BannerListScreen> {


  late Future<void> futureGetData;
  bool isLoading = false;
  List<BannerModel> bannerList = [];
  late AdminProvider adminProvider;
  late AdminController adminController;


  Future<void> getData() async {
    MyPrint.printOnConsole('Banner list length in provider:${adminProvider.propertyModel.get()?.banners.length}');
    bannerList = (adminProvider.propertyModel.get()?.banners.values.toList() ?? []).map((e) {
      return BannerModel.fromMap(e.toMap());
    }).toList();
    bannerList.sort((a, b) => a.viewNumber.compareTo(b.viewNumber));
    MyPrint.printOnConsole('hi list: ${bannerList.length}');
  }

  Future<void> deleteBanner(BannerModel bannerModel) async {
    showDialog(
      context: context,
      builder: (context) {
        return CommonPopup(
          text: "Want to Delete this banner?",
          rightText: "Yes",
          rightOnTap: () async {
             await adminController.deleteBannerFromFirebase(bannerModel: bannerModel);
             Navigator.pop(context);
             setState(() {

             });
          },
        );
      },
    );
  }

  Future<void> editBanner(BannerModel bannerModel,int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return CommonPopup(
          text: "Want to Edit this banner?",
          rightText: "Yes",
          rightOnTap: () async {
            NavigationController.navigateToAddBannerScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  navigationType: NavigationType.pushNamed,
                  context: NavigationController.systemProfileNavigator.currentContext!,
                ),
              addBannerScreenNavigationArguments: AddBannerScreenNavigationArguments(
                bannerModel: bannerModel,
                index: index,
                isEdit: true,
              ),

            );
            Navigator.pop(context);

          },
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    adminProvider = context.read<AdminProvider>();
    adminController = AdminController(adminProvider : adminProvider);
    futureGetData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: futureGetData,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: const Center(child: LoadingWidget()),
            child:Scaffold(
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
                    ),
                  addBannerScreenNavigationArguments: AddBannerScreenNavigationArguments()
                );

              }),
          ),
          SizedBox(height:15),
          Expanded(child: getListView()),
        ],
      ),
    )
        );
      } else {
        return const Center(child: LoadingWidget());
      }
        });
  }

  Widget getListView(){
    return ReorderableListView.builder(
        itemBuilder: (context,index){
          return getBannerWidget(bannerList[index],index);
        },
        itemCount: bannerList.length,
        onReorder: reorderData
    );
  }

  Widget getBannerWidget(BannerModel banner,int index){
    return Container(
      key: ValueKey(index),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Styles.bgSideMenu,width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonText(text: '${banner.viewNumber}.',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 30,),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Styles.bgSideMenu,width: .5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CommonCachedNetworkImage(
              imageUrl: banner.imageUrl,
              borderRadius: 8,
            ),
          ),
          SizedBox(width: 30,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                text: banner.createdTime == null
                    ? 'Banner Created Date: No Data'
                    : 'Banner Created Date: ${DateFormat("dd-MMM-yyyy").format(banner.createdTime!.toDate())}',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 5,),
              CommonText(
                text: banner.isInternal ? 'Internal Click' : 'External Click',
                fontSize: 17,
              ),
              SizedBox(height: 5,),
              CommonText(
                text: banner.isInternal ? 'Internal Feature Type : ${banner.internalFeatureType}\nRouting Screen Name : ${banner.internalScreenName}' : 'External Click Url : ${banner.externalUrl}',
                fontSize: 17,
              ),
            ],
          ),
          Expanded(child: Container(),),
          SizedBox(width: 15,),
          InkWell(
              onTap: () async {
                await editBanner(banner,index) ;
              },
              child: Tooltip(
                message: 'edit banner',
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.edit,color: Styles.bgSideMenu,),
                ),
              )),
          InkWell(
              onTap: () async {
                await deleteBanner(banner) ;
              },
              child: Tooltip(
                message: 'delete banner',
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.delete,color: Colors.red,),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> reorderData(int oldIndex, int newIndex) async {
    // bannerList[oldIndex].viewNumber = newIndex;
    // await adminController.reorderBannerListToFirebase(bannerList: bannerList);
  }



}



