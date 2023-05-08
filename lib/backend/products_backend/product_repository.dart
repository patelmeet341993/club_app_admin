
import 'package:club_model/utils/my_print.dart';

import '../../models/product/product_model.dart';

class ProductRepository{

  Future<List<ProductModel>> getProductListRepo() async {
    List<ProductModel> productList = [];

    try{
      // MyFirestoreQuerySnapshot querySnapshot = await FirebaseNodes.gamesCollectionReference.get();
      // if(querySnapshot.docs.isNotEmpty){
      //   for (MyFirestoreQueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
      //     if(queryDocumentSnapshot.data().isNotEmpty) {
      //       productList.add(GameModel.fromMap(queryDocumentSnapshot.data()));
      //     }
      //     else {
      //       MyPrint.printOnConsole("Game Document Empty for Document Id:${queryDocumentSnapshot.id}");
      //     }
      //   }
      // }
    }catch(e,s){
      MyPrint.printOnConsole('Error in getGamesListRepo in GameRepository $e');
      MyPrint.printOnConsole(s);
    }

    return productList;
  }

  Future<void> AddGameRepo(ProductModel productModel) async {
    // await FirebaseNodes.gameDocumentReference(gameId: gameModel.id).set(gameModel.toMap());
  }

}