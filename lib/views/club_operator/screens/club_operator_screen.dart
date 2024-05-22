import 'package:club_app_admin/backend/club_operator_backend/club_operator_controller.dart';
import 'package:club_app_admin/backend/club_operator_backend/club_operator_provider.dart';
import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_app_admin/configs/constants.dart';
import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/club/data_model/club_operator_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_popup.dart';

class ClubOperatorScreenNavigator extends StatefulWidget {
  const ClubOperatorScreenNavigator({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClubOperatorScreenNavigatorState createState() => _ClubOperatorScreenNavigatorState();
}

class _ClubOperatorScreenNavigatorState extends State<ClubOperatorScreenNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.clubOperatorNavigator,
      onGenerateRoute: NavigationController.onClubOperatorGeneratedRoutes,
    );
  }
}

class ClubOperatorListScreen extends StatefulWidget {
  const ClubOperatorListScreen({Key? key}) : super(key: key);

  @override
  State<ClubOperatorListScreen> createState() => _ClubOperatorListScreenState();
}

class _ClubOperatorListScreenState extends State<ClubOperatorListScreen> {
  late ClubOperatorProvider clubOperatorProvider;
  late ClubOperatorController clubOperatorController;
  late Future<void> futureGetData;
  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    await clubOperatorController.getClubOperatorFromFirebase(isNotify: false);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteClubOperator(ClubOperatorModel clubOperatorModel) async {
    dynamic value = await showDialog(
      context: context,
      builder: (context) {
        return CommonPopup(
          text: "Want to Delete this club?",
          rightText: "Yes",
          rightOnTap: () async {
            // ignore: use_build_context_synchronously
            Navigator.pop(context, true);
          },
        );
      },
    );

    if(value != true) {
      return;
    }

    await clubOperatorController.deleteClubOperatorFromFirebase(clubOperatorModel);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    clubOperatorProvider = context.read<ClubOperatorProvider>();
    clubOperatorController = ClubOperatorController(clubOperatorProvider: clubOperatorProvider);
    futureGetData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureGetData,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
      return Scaffold(
        body: Column(
          children: [
            HeaderWidget(
              title: "Club Operators",
              suffixWidget: CommonButton(
                  text: "Add Club Operator",
                  icon: Icon(
                    Icons.add,
                    color: Styles.white,
                  ),
                  onTap: () {
                    BuildContext? context = NavigationController.clubOperatorNavigator.currentContext;
                    if (context == null) return;
                    NavigationController.navigateToAddClubOperatorScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        navigationType: NavigationType.pushNamed,
                        context: context,
                      ),
                      addClubOperatorNavigationArguments: AddClubOperatorNavigationArguments(),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: getClubOperatorsList()),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
      } else {
        return const Center(child: LoadingWidget());
      }
        }
    );
  }

  Widget getClubOperatorsList() {
    return Consumer(
        builder: (BuildContext context,ClubOperatorProvider clubOperatorProvider,Widget? child){
          if(clubOperatorProvider.clubOperatorList.length<1){
            return Center(
              child: CommonText(
                text: "No Club Operators Available",
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            );
          }

          //List<NewsFeedModel> newsList = newsProvider.newsList;
          return ListView.builder(
            itemCount: clubOperatorProvider.clubOperatorList.length +1 ,
            //shrinkWrap: true,
            itemBuilder: (context,index){
              if((index == 0 && clubOperatorProvider.clubOperatorList.length == 0) || (index ==  clubOperatorProvider.clubOperatorList.length)){
                if(clubOperatorProvider.clubOperatorsLoading.get()){
                  return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Styles.bgColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(child: CircularProgressIndicator(color: Styles.bgSideMenu)),
                  );
                }else{
                  return const SizedBox();
                }

              }

              if(clubOperatorProvider.hasMoreClubOperators.get() && index > (clubOperatorProvider.clubOperatorList.length - MyAppConstants.clubOperatorRefreshIndexForPagination)) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  clubOperatorController.getClubOperatorFromFirebase(isRefresh: false,isNotify: false);
                });
              }


              return SingleClubOperator(clubOperatorProvider.clubOperatorList.getList()[index],index);
            },
          );
        }
    );
  }

  Widget SingleClubOperator(ClubOperatorModel clubOperatorModel, index) {
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
                imageUrl: clubOperatorModel.profileImageUrl,
                height: 80,
                width: 80,
                borderRadius: 4,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: clubOperatorModel.name,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                CommonText(
                  text: 'Mobile Number: ${clubOperatorModel.mobileNumber}',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(height: 3),
                CommonText(
                  text: clubOperatorModel.createdTime == null
                      ? 'Created Date: No Data'
                      : 'Created Date: ${DateFormat("dd-MMM-yyyy").format(clubOperatorModel.createdTime!.toDate())}',
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
                            text: "Want to Edit this Club Operator?",
                            rightText: "Yes",
                            rightOnTap: () async {
                              Navigator.pop(context);
                              await NavigationController.navigateToAddClubOperatorScreen(
                                navigationOperationParameters: NavigationOperationParameters(
                                  navigationType: NavigationType.pushNamed,
                                  context: NavigationController.clubOperatorNavigator.currentContext!,
                                ),
                                addClubOperatorNavigationArguments: AddClubOperatorNavigationArguments(
                                  clubOperatorModel: clubOperatorModel,
                                  index: index,
                                  isEdit: true,
                                ),
                              );
                              getData();
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
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                    onTap: () async {
                      await deleteClubOperator(clubOperatorModel);
                    },
                    child: const Tooltip(
                      message: 'delete club',
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    CommonText(text: 'Admin'),
                    const SizedBox(
                      height: 3,
                    ),
                    getEnableSwitch(
                        value: clubOperatorModel.adminEnabled,
                        onChanged: (val) async {
                          await clubOperatorController.EnableDisableClubOperatorInFirebase(
                            adminEnabled: val ?? true,
                            id: clubOperatorModel.id,
                            model: clubOperatorModel,
                          );
                          setState((){});
                        }
                        ),
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
