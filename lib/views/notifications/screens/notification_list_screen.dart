import 'package:club_model/backend/notification/notification_controller.dart';
import 'package:club_model/backend/notification/notification_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/common/data_model/notication_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';
import '../../common/components/header_widget.dart';

class NotificationListScreenNavigator extends StatefulWidget {
  const NotificationListScreenNavigator({Key? key}) : super(key: key);

  @override
  State<NotificationListScreenNavigator> createState() => _NotificationListScreenNavigatorState();
}

class _NotificationListScreenNavigatorState extends State<NotificationListScreenNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.notificatioScreenNavigator,
      onGenerateRoute: NavigationController.onNotificationGeneratedRoutes,
    );
  }
}

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {

  late NotificationProvider notificationProvider;
  late NotificationController notificationController;
  late Future<void> futureGetData;
  bool isLoading = false;

  Future<void> getData() async {
    await notificationController.getNotificationListFromFirebase(isNotify: false);
  }

  @override
  void initState() {
    super.initState();
    notificationProvider = context.read<NotificationProvider>();
    notificationController = NotificationController(notificationProvider: notificationProvider);
    futureGetData = getData();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureGetData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Styles.bgColor,
              body: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Column(
                  children: [
                    HeaderWidget(
                      title: "Notifications",
                      suffixWidget: CommonButton(
                          text: "Add Notification",
                          icon: Icon(
                            Icons.add,
                            color: Styles.white,
                          ),
                          onTap: () {
                            NavigationController.navigateToAddNotificationScreen(
                                navigationOperationParameters:
                                NavigationOperationParameters(
                                  navigationType: NavigationType.pushNamed,
                                  context: context,
                                ),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(child: getNotificationList()),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: LoadingWidget());
          }
        });
  }

  Widget getNotificationList() {
    return Consumer(
        builder: (BuildContext context,NotificationProvider notificationProvider,Widget? child){
          if(notificationProvider.notificationList.length<1){
            return Center(
              child: CommonText(
                text: "No Notification Available",
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            );
          }

          //List<NewsFeedModel> newsList = newsProvider.newsList;
          return ListView.builder(
            itemCount: notificationProvider.notificationList.length +1 ,
            //shrinkWrap: true,
            itemBuilder: (context,index){
              if((index == 0 && notificationProvider.notificationList.length == 0) || (index ==  notificationProvider.notificationList.length)){
                if(notificationProvider.notificationLoading.get()){
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Styles.bgColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(child: CircularProgressIndicator(color: Styles.bgSideMenu)),
                  );
                }else{
                  return SizedBox();
                }

              }

              if(notificationProvider.hasMoreNotifications.get() && index > (notificationProvider.notificationList.length - AppConstants.notificationRefreshIndexForPagination)) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  notificationController.getNotificationListFromFirebase(isRefresh: false,isNotify: false);
                });
              }


              return getNotificationTile(notificationProvider.notificationList.getList()[index],index);
            },
          );
        }
    );
  }


  Widget getNotificationTile(NotificationModel notificationModel, int index){
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 5,),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius : BorderRadius.circular(4),
          border: Border.all(width: 1,color: Styles.bgSideMenu),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: CommonText(text: '${notificationModel.title}', fontSize:16,fontWeight: FontWeight.bold,)),
              CommonText(text: notificationModel.createdTime == null ? '' : "${DateFormat("h:mm a, dd-MMM-yyyy").format(notificationModel.createdTime!.toDate())}",fontSize: 13,)
            ],
          ),
          SizedBox(height: 3,),
          CommonText(text: notificationModel.description,textAlign: TextAlign.start,fontSize: 14),
          SizedBox(height: 3,),
        ],
      ),

    );
  }


}

