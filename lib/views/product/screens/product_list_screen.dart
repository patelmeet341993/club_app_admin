import 'package:club_app_admin/backend/products_backend/product_controller.dart';
import 'package:club_app_admin/backend/products_backend/product_provider.dart';
import 'package:club_app_admin/models/product/product_model.dart';
import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../common/components/common_button.dart';


class ProductScreenNavigator extends StatefulWidget {
  const ProductScreenNavigator({Key? key}) : super(key: key);

  @override
  _ProductScreenNavigatorState createState() => _ProductScreenNavigatorState();
}

class _ProductScreenNavigatorState extends State<ProductScreenNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.productScreenNavigator,
      onGenerateRoute: NavigationController.onProductGeneratedRoutes,
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider productProvider;
  late ProductController productController;
  late Future<void> futureGetData;
  bool isLoading = false;

  Future<void> getData() async {

    await productController.getGameList();


  }

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productController = ProductController(productProvider: productProvider);
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
                    HeaderWidget(title: "Products",suffixWidget: CommonButton(text: "Add Product",
                        icon: Icon(Icons.add,color: Styles.white,),
                        onTap: (){
                          NavigationController.navigateToAddProductScreen(navigationOperationParameters:
                          NavigationOperationParameters(
                            navigationType: NavigationType.pushNamed,
                            context: context,

                          ));
                        }),),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(child: getGamesList()),
                  ],
                ),
              ),
            );
          } else {
            return const LoadingWidget();
          }
        });
  }

  Widget getGamesList() {
    return Consumer(builder:
        (BuildContext context, ProductProvider productProvider, Widget? child) {
      if (productProvider.productsList.isEmpty) {
        return Center(
          child: CommonText(
            text: "No Products Available",
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        );
      }

      //List<NewsFeedModel> newsList = newsProvider.newsList;
      return ListView.builder(
        itemCount: productProvider.productsList.length,
        //shrinkWrap: true,
        itemBuilder: (context, index) {
          return SingleGame(productProvider.productsList[index], index);
        },
      );
    });
  }

  Widget SingleGame(ProductModel gameModel, index){
    return Container()
;  }

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
