import 'package:club_app_admin/backend/products_backend/product_provider.dart';
import 'package:club_app_admin/backend/products_backend/product_repository.dart';
import 'package:club_app_admin/models/product/product_model.dart';
import 'package:club_model/utils/my_print.dart';

class ProductController {

  late ProductProvider productProvider;
  late ProductRepository productRepository;

  ProductController({required this.productProvider,ProductRepository?  repository}){
    productRepository =  repository ??  ProductRepository();
  }

  Future<void> getGameList() async {
    // List<ProductModel> productList = [];
    // productList = await gameRepository.getGamesListRepo();
    // if(productList.isNotEmpty){
    //   gameProvider.setGamesList(productList);
    // }
  }


  Future<void> EnableDisableGameInFirebase({required Map<String,dynamic> editableData,required String id,required int listIndex}) async {

    try{

      // await FirebaseNodes.gameDocumentReference(gameId: id)
      //     .update(editableData).then((value) {
      //   MyPrint.printOnConsole("user data: ${editableData["enabled"]}");
      //   gameProvider.updateEnableDisableOfList(editableData["enabled"] , listIndex);
      // });
    }catch(e,s){
      MyPrint.printOnConsole("Error in Enable Disable User in firebase in User Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> AddGameToFirebase(ProductModel productModel) async {
    try{
      await productRepository.AddGameRepo(productModel);
      productProvider.addGameModelInGameList(productModel);

    }catch(e,s){
      MyPrint.printOnConsole('Error in Add Game to Firebase in Game Controller $e');
      MyPrint.printOnConsole(s);
    }

  }



}