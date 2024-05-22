import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../backend/users_backend/local_user_controller.dart';
import '../../../backend/users_backend/user_provider.dart';
import '../../../configs/constants.dart';
import '../../common/components/header_widget.dart';
import '../../common/components/table/my_table_cell_model.dart';
import '../../common/components/table/my_table_row_widget.dart';

class DisabledUsersList extends StatefulWidget {
  static const String routeName = "/DisabledUsersList";

  const DisabledUsersList({Key? key}) : super(key: key);

  @override
  State<DisabledUsersList> createState() => _DisabledUsersListState();
}

class _DisabledUsersListState extends State<DisabledUsersList> {
  late UserProvider userProvider;
  late LocalUserController userController;

  List<int> flexes = [1, 2, 1, 1, 1];
  List<String> titles = ["Sr No.", "Name", "Mobile Number", "DOB", "Enabled"];
  late Future<void> futureGetData;

  Future<void> getUsersData() async {
    await userController.getAllDisabledUsersFromFirebase(isNotify: false);
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userController = LocalUserController(userProvider: userProvider);
    futureGetData = getUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureGetData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Styles.bgColor,
              body: Column(
                children: [
                  HeaderWidget(
                    title: "Blocked Users",
                    isBackArrow: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTableRowWidget(
                    backgroundColor: Styles.bgSideMenu,
                    cells: [
                      ...List.generate(titles.length, (index) {
                        return MyTableCellModel(
                            flex: flexes[index],
                            child: CommonText(
                              text: titles[index],
                              color: Styles.white,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ));
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: getUsersList(),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: LoadingWidget());
          }
        });
  }

  Widget getUsersList() {
    return Consumer(builder:
        (BuildContext context, UserProvider userProvider, Widget? child) {
      if (userProvider.disabledUsersList.isEmpty) {
        return Center(
          child: CommonText(
            text: "No Blocked Users",
            fontWeight: FontWeight.bold,
          ),
        );
      }

      //List<NewsFeedModel> newsList = newsProvider.newsList;
      return ListView.builder(
        itemCount: userProvider.disabledUsersList.length + 1,
        //shrinkWrap: true,
        itemBuilder: (context, index) {
          if ((index == 0 && userProvider.disabledUsersListLength == 0) ||
              (index == userProvider.disabledUsersListLength)) {
            if (userProvider.getIsDisabledUsersLoading) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Styles.bgColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                    child: CircularProgressIndicator(color: Styles.bgSideMenu)),
              );
            } else {
              return const SizedBox();
            }
          }

          if (userProvider.getHasMoreDisabledUsers &&
              index >
                  (userProvider.disabledUsersListLength -
                      MyAppConstants.userRefreshIndexForPagination)) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              MyPrint.printOnConsole("Ye wali Method call");
              userController.getAllDisabledUsersFromFirebase(
                  isRefresh: false, isNotify: false);
            });
          }

          return singleUser(userProvider.disabledUsersList[index], index);
        },
      );
    });
  }

  Widget singleUser(UserModel userModel, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: MyTableRowWidget(
        backgroundColor: Colors.white,
        cells: [
          MyTableCellModel(
            flex: flexes[0],
            child: CommonText(
              text: "${index + 1}",
              textAlign: TextAlign.center,
            ),
          ),
          MyTableCellModel(
            flex: flexes[1],
            child: CommonText(
              text: userModel.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              textOverFlow: TextOverflow.ellipsis,
            ),
          ),
          MyTableCellModel(
            flex: flexes[2],
            child: CommonText(
              text: userModel.mobileNumber,
              textAlign: TextAlign.center,
              maxLines: 2,
              textOverFlow: TextOverflow.ellipsis,
            ),
          ),
          MyTableCellModel(
            flex: flexes[3],
            child: CommonText(
              text: userModel.dateOfBirth == null
                  ? 'No Data'
                  : DateFormat("dd-MMM-yyyy")
                      .format(userModel.dateOfBirth!.toDate()),
              textAlign: TextAlign.center,
            ),
          ),
          MyTableCellModel(
            flex: flexes[4],
            child: getTestEnableSwitch(
                value: userModel.adminEnabled,
                onChanged: (val) {
                  Map<String, dynamic> data = {
                    "adminEnabled": val,
                  };
                  userController.EnableDisableDisabledUserInFirebase(
                      editableData: data, id: userModel.id, listIndex: index);
                }),
          ),
        ],
      ),
    );
  }

  Widget getTestEnableSwitch(
      {required bool value, void Function(bool?)? onChanged}) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Styles.bgSideMenu,
    );
  }
}
