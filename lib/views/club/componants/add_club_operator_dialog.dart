import 'package:club_app_admin/backend/club_operator_backend/club_operator_controller.dart';
import 'package:club_app_admin/backend/club_operator_backend/club_operator_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/club/data_model/club_operator_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

import '../../../configs/constants.dart';

class AddClubOperatorDialog extends StatefulWidget {
  ClubOperatorProvider clubOperatorProvider;

  AddClubOperatorDialog({required this.clubOperatorProvider});

  @override
  State<AddClubOperatorDialog> createState() => _AddClubOperatorDialogState();
}

class _AddClubOperatorDialogState extends State<AddClubOperatorDialog> {
  late ClubOperatorProvider pageClubOperatorProvider;
  late ClubOperatorController clubOperatorController;
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

  @override
  void initState() {
    super.initState();
    pageClubOperatorProvider = widget.clubOperatorProvider;
    clubOperatorController = ClubOperatorController(clubOperatorProvider: pageClubOperatorProvider);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: pageClubOperatorProvider),
      ],
      child: Consumer(builder: (BuildContext context, ClubOperatorProvider clubOperatorProvider, Widget? child) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Container(
            height: MediaQuery.of(context).size.height * .7,
            width: MediaQuery.of(context).size.width * .5,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getDialogHeaderWidget(title: 'Choose Club Owner',),
                SizedBox(
                  height: 10,
                ),
                isLoading ? Center(child: LoadingWidget()) : getClubOperatorList(clubOperatorProvider)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget getDialogHeaderWidget({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: CommonText(
          text: title,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          maxLines: 1,
        )),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.close, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget getClubOperatorWidget(ClubOperatorModel clubOperatorModel, index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(5),
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
              height: 35,
              width: 35,
              borderRadius: 4,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: clubOperatorModel.name,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,

                  textOverFlow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                CommonText(
                  text: 'Mobile Number: ${clubOperatorModel.mobileNumber}',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  textOverFlow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 3),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: clubOperatorModel.emailId,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  textOverFlow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 5),
                CommonText(
                  text: clubOperatorModel.createdTime == null
                      ? 'Created Date: No Data'
                      : 'Created Date: ${DateFormat("dd-MMM-yyyy").format(clubOperatorModel.createdTime!.toDate())}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  textOverFlow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getClubOperatorList(ClubOperatorProvider clubOperatorProvider) {
    if (clubOperatorProvider.clubOperatorList.length < 1) {
      return Center(
        child: CommonText(
          text: "No Club Operators Available",
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: clubOperatorProvider.clubOperatorList.length + 1,
          //shrinkWrap: true,
          itemBuilder: (context, index) {
            if ((index == 0 && clubOperatorProvider.clubOperatorList.length == 0) || (index == clubOperatorProvider.clubOperatorList.length)) {
              if (clubOperatorProvider.clubOperatorsLoading.get()) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Styles.bgColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(child: CircularProgressIndicator(color: Styles.bgSideMenu)),
                );
              } else {
                return const SizedBox();
              }
            }

            if (clubOperatorProvider.hasMoreClubOperators.get() &&
                index > (clubOperatorProvider.clubOperatorList.length - MyAppConstants.clubOperatorRefreshIndexForPagination)) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                clubOperatorController.getClubOperatorFromFirebase(isRefresh: false, isNotify: false);
              });
            }

            return getClubOperatorWidget(clubOperatorProvider.clubOperatorList.getList()[index], index);
          },
        ),
      );
    }
  }
}
