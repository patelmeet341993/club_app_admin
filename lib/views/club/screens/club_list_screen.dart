import 'package:club_app_admin/backend/club_backend/club_controller.dart';
import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/configs/constants.dart';
import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';

class ClubScreenNavigator extends StatefulWidget {
  const ClubScreenNavigator({Key? key}) : super(key: key);

  @override
  _ClubScreenNavigatorState createState() => _ClubScreenNavigatorState();
}

class _ClubScreenNavigatorState extends State<ClubScreenNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.clubScreenNavigator,
      onGenerateRoute: NavigationController.onClubGeneratedRoutes,
    );
  }
}

class ClubListScreen extends StatefulWidget {
  const ClubListScreen({Key? key}) : super(key: key);

  @override
  State<ClubListScreen> createState() => _ClubListScreenState();
}

class _ClubListScreenState extends State<ClubListScreen> {
  late ClubProvider clubProvider;
  late ClubController clubController;
  late Future<void> futureGetData;
  bool isLoading = false;

  Future<void> getData() async {
    await clubController.getClubList();
  }

  @override
  void initState() {
    super.initState();
    clubProvider = Provider.of<ClubProvider>(context, listen: false);
    clubController = ClubController(clubProvider: clubProvider);
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
                      title: "Clubs",
                      suffixWidget: CommonButton(
                          text: "Add Club",
                          icon: Icon(
                            Icons.add,
                            color: Styles.white,
                          ),
                          onTap: () async {
                            // String newId = MyUtils.getNewId();
                            // ClubModel clubModel = ClubModel(
                            //     thumbnailImageUrl: "https://picsum.photos/200/300?grayscale",
                            //     name: "Waves Club",
                            //     address: "Kedar Bumiya Marg, opp. Narayan Essenza, Bhayli, Vadodara, Gujarat 391410",
                            //     clubEnabled: true,
                            //     createdTime: Timestamp.now(),
                            //     images: ["https://picsum.photos/200/300/?blur", "https://picsum.photos/200/300/?blur=2"],
                            //     location: LocationModel(
                            //       address: "Kedar Bumiya Marg, opp. Narayan Essenza, Bhayli, Vadodara, Gujarat 391410",
                            //       city: "Vadodara",
                            //       state: "Gujarat",
                            //       timestamp: Timestamp.now(),
                            //     ),
                            //   mobileNumber: "7621855610",
                            //   adminEnabled: true,
                            //   id: newId,
                            // );
                            // await FirestoreController.firestore.collection('clubs')
                            //     .doc(newId).set(clubModel.toMap());
                            // NavigationController.navigateToAddClubScreen(navigationOperationParameters:
                            // NavigationOperationParameters(
                            //   navigationType: NavigationType.pushNamed,
                            //   context: context,
                            // ));
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(child: getClubsList()),
                  ],
                ),
              ),
            );
          } else {
            return const LoadingWidget();
          }
        });
  }

  Widget getClubsList() {
    return Consumer(builder: (BuildContext context, ClubProvider clubProvider, Widget? child) {
      if (clubProvider.clubsList.isEmpty) {
        return Center(
          child: CommonText(
            text: "No Clubs Available",
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        );
      }

      //List<NewsFeedModel> newsList = newsProvider.newsList;
      return ListView.builder(
        itemCount: clubProvider.clubsList.length,
        //shrinkWrap: true,
        itemBuilder: (context, index) {
          return SingleGame(clubProvider.clubsList[index], index);
        },
      );
    });
  }

  Widget SingleGame(ClubModel gameModel, index) {
    return Container();
  }

/*  Widget SingleProduct(GameModel gameModel, index) {
    return InkWell(
      onTap: (){

      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Styles.white,
          border: Border.all(color: Styles.yellow, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Styles.bgSideMenu.withOpacity(.6)),
                ),
                child: CommonCachedNetworkImage(
                  imageUrl: gameModel.thumbnailImage,
                  height: 80,
                  width: 80,
                  borderRadius: 4,
                )),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: gameModel.name,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10),
                CommonText(
                  text: gameModel.createdTime == null
                      ? 'Created Date: No Data'
                      : 'Created Date: ${DateFormat("dd-MMM-yyyy").format(gameModel.createdTime!.toDate())}',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  textOverFlow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Spacer(),
            // InkWell(
            //   onTap: (){},
            //   child: Tooltip(
            //     message: 'Copy New Game',
            //     child: Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Icon(Icons.copy,color: AppColor.bgSideMenu),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 20,
            ),
            getTestEnableSwitch(
                value: gameModel.enabled,
                onChanged: (val) {
                  Map<String, dynamic> data = {
                    "enabled": val,
                  };
                  productController.EnableDisableGameInFirebase(
                      editableData: data, id: gameModel.id, listIndex: index);
                })
          ],
        ),
      ),
    );
  }

  Widget getTestEnableSwitch(
      {required bool value, void Function(bool?)? onChanged}) {
    return Tooltip(
      message: value ?'Enabled' : 'Disabled',
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: Styles.bgSideMenu,
      ),
    );
  }*/
}
