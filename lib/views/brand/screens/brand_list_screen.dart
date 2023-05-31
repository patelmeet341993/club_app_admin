import 'dart:typed_data';

import 'package:club_app_admin/backend/brands_backend/brand_provider.dart';
import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

import '../../../backend/brands_backend/brand_controller.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_popup.dart';

class BrandListScreenNavigator extends StatefulWidget {
  const BrandListScreenNavigator({Key? key}) : super(key: key);

  @override
  _BrandListScreenNavigatorState createState() => _BrandListScreenNavigatorState();
}

class _BrandListScreenNavigatorState extends State<BrandListScreenNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.brandScreenNavigator,
      onGenerateRoute: NavigationController.onBrandGeneratedRoutes,
    );
  }
}

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({Key? key}) : super(key: key);

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {

  late BrandProvider brandProvider;
  late BrandController brandController;
  late Future<void> futureGetData;
  bool isLoading = false;


  Future<void> getData() async {
    await brandController.getBrandList();
  }

  @override
  void initState() {
    super.initState();
    brandProvider = Provider.of<BrandProvider>(context, listen: false);
    brandController = BrandController(brandProvider: brandProvider);
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
                      title: "Brands",
                      suffixWidget: CommonButton(
                          text: "Add Brand",
                          icon: Icon(
                            Icons.add,
                            color: Styles.white,
                          ),
                          onTap: () {
                            NavigationController.navigateToAddBrandScreen(
                                navigationOperationParameters:
                                NavigationOperationParameters(
                                  navigationType: NavigationType.pushNamed,
                                  context: context,
                                ),
                                addBrandScreenNavigationArguments: AddBrandScreenNavigationArguments()
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(child: getBrandList()),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: LoadingWidget());
          }
        });
  }

  Widget getBrandList() {
    return Consumer(builder:
        (BuildContext context, BrandProvider brandProvider, Widget? child) {
      if (brandProvider.brandsList.isEmpty) {
        return Center(
          child: CommonText(
            text: "No Brands Available",
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        );
      }

      //List<NewsFeedModel> newsList = newsProvider.newsList;
      return ListView.builder(
        itemCount: brandProvider.brandsList.length,
        //shrinkWrap: true,
        itemBuilder: (context, index) {
          return SingleBrand(brandProvider.brandsList[index], index);
        },
      );
    });
  }

  Widget SingleBrand(BrandModel brandModel, index) {
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
                  imageUrl: brandModel.thumbnailImageUrl,
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
                  text: brandModel.name,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 3),
                CommonText(
                  text: brandModel.createdTime == null
                      ? 'Created Date: No Data'
                      : 'Created Date: ${DateFormat("dd-MMM-yyyy").format(brandModel.createdTime!.toDate())}',
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
            const SizedBox(
              width: 10,
            ),
            Tooltip(
              message: 'Edit Brand',
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CommonPopup(
                        text: "Want to Edit brand?",
                        rightText: "Yes",
                        rightOnTap: () async {
                          NavigationController.navigateToAddBrandScreen(
                            navigationOperationParameters: NavigationOperationParameters(
                              navigationType: NavigationType.pushNamed,
                              context: NavigationController.brandScreenNavigator.currentContext!,
                            ),
                            addBrandScreenNavigationArguments: AddBrandScreenNavigationArguments(
                              brandModel: brandModel,
                              index: index,
                              isEdit: true,
                            ),
                          );
                          Navigator.pop(context);
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
                      size: 22,
                    )),
              ),
            ),
            const SizedBox(
              width: 0,
            ),
          ],
        ),
      ),
    );
  }

/*
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
  }

  getTestEnableSwitch(
  value: productModel.enabled,
  onChanged: (val) {
  Map<String, dynamic> data = {
  "enabled": val,
  };
  productController.EnableDisableGameInFirebase(
  editableData: data, id: productModel.id, listIndex: index);
  })*/
}
