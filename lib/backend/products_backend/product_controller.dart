

import 'package:club_app_admin/backend/products_backend/product_provider.dart';
import 'package:club_app_admin/backend/products_backend/product_repository.dart';
import 'package:club_model/club_model.dart';

class ProductController {

  late ProductProvider productProvider;
  late ProductRepository productRepository;

  ProductController({required this.productProvider,ProductRepository?  repository}){
    productRepository =  repository ??  ProductRepository();
  }

  Future<void> getProductList() async {
    List<ProductModel> productList = [];
    productList = await productRepository.getProductListRepo();
    if(productList.isNotEmpty){
      productProvider.setProductsList(productList);
    }
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

  Future<void> AddProductToFirebase(ProductModel productModel) async {
    try{
      await productRepository.AddProductRepo(productModel);
      productProvider.addProductModelInGameList(productModel);

    }catch(e,s){
      MyPrint.printOnConsole('Error in Add Product to Firebase in Product Controller $e');
      MyPrint.printOnConsole(s);
    }

  }



}