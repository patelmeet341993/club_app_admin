

import 'dart:io';
import 'dart:typed_data';

import 'package:club_app_admin/backend/products_backend/product_provider.dart';
import 'package:club_app_admin/backend/products_backend/product_repository.dart';
import 'package:club_model/club_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> addProductToFirebase(ProductModel productModel) async {
    try{
      await productRepository.AddProductRepo(productModel);
      productProvider.addProductModelInGameList(productModel);

    }catch(e,s){
      MyPrint.printOnConsole('Error in Add Product to Firebase in Product Controller $e');
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> updateProductToFirebase(ProductModel productModel) async {
    try{
      await productRepository.UpdateProductRepo(productModel);
      getProductList();
    }catch(e,s){
      MyPrint.printOnConsole('Error in Add Product to Firebase in Product Controller $e');
      MyPrint.printOnConsole(s);
    }
  }

  Future<String> uploadImageToFirebase(XFile imageFile, ) async {
    String imageUrl = "";

    try {
      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Uint8List? imageData  = await imageFile.readAsBytes();
      String type = imageFile.mimeType?.split("/").last ?? "";
      // Reference the Firebase Storage location to upload the file
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName.$type');


      // Upload the image file to Firebase Storage
      UploadTask uploadTask = storageReference.putData(imageData, SettableMetadata(contentType: imageFile.mimeType));
      await uploadTask.whenComplete(() {});

      // Retrieve the download URL of the uploaded image
      imageUrl = await storageReference.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }

    return imageUrl;
  }


}