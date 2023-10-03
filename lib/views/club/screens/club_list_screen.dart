import 'package:club_app_admin/backend/club_backend/club_controller.dart';
import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_app_admin/configs/constants.dart';
import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_popup.dart';

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
                          onTap: () {
                            BuildContext? context = NavigationController.clubScreenNavigator.currentContext;
                            if(context == null) return;
                            NavigationController.navigateToAddClubScreen(
                              navigationOperationParameters: NavigationOperationParameters(
                                navigationType: NavigationType.pushNamed,
                                context: context,
                              ),
                              addClubScreenNavigationArguments: AddClubScreenNavigationArguments(),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(child: getClubsList()),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: LoadingWidget());
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
          return SingleClub(clubProvider.clubsList[index], index);
        },
      );
    });
  }

  Widget SingleClub(ClubModel clubModel, index) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(10),
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
                  imageUrl: clubModel.thumbnailImageUrl,
                  height: 80,
                  width: 80,
                  borderRadius: 4,
                )),
            const SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: clubModel.name,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                CommonText(
                  text: 'Mobile Number: ${clubModel.mobileNumber}',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(height: 3),
                CommonText(
                  text: clubModel.createdTime == null
                      ? 'Created Date: No Data'
                      : 'Created Date: ${DateFormat("dd-MMM-yyyy").format(clubModel.createdTime!.toDate())}',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontSize: 14,
                  textOverFlow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            const Spacer(),
            Row(
              children: [
                Tooltip(
                  message: 'Edit Club',
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CommonPopup(
                            text: "Want to Edit Club?",
                            rightText: "Yes",
                            rightOnTap: () async {
                              Navigator.pop(context);
                              NavigationController.navigateToAddClubScreen(
                                navigationOperationParameters: NavigationOperationParameters(
                                  navigationType: NavigationType.pushNamed,
                                  context: NavigationController.clubScreenNavigator.currentContext!,
                                ),
                                addClubScreenNavigationArguments: AddClubScreenNavigationArguments(
                                  clubModel: clubModel,
                                  index: index,
                                  isEdit: true,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: const Icon(
                          Icons.edit,
                          color: Styles.bgSideMenu,
                          size: 28,
                        )),
                  ),
                ),
                SizedBox(width: 15,),
                InkWell(
                    onTap: () async {},
                    child: Tooltip(
                      message: 'delete banner',
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.delete,color: Colors.red,),
                      ),
                    )),
                SizedBox(width: 15,),
                Column(
                  children: [
                    CommonText(text: 'Admin'),
                    const SizedBox(
                      height: 3,
                    ),
                    getEnableSwitch(
                        value: clubModel.adminEnabled,
                        onChanged: (val) {
                          Map<String, dynamic> data = {
                            MyAppConstants.cAdminEnabled: val,
                          };
                          clubController.EnableDisableClubInFirebase(
                            editableData: data,
                            id: clubModel.id,
                            listIndex: index,
                          );
                        }),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget getEnableSwitch({
    required bool value,
    void Function(bool?)? onChanged,
  }) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Styles.bgSideMenu,
    );
  }
}
