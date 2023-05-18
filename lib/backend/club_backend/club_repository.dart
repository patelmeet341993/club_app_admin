import 'package:club_model/club_model.dart';

class ClubRepository {
  Future<List<ClubModel>> getClubListRepo() async {
    List<ClubModel> clubList = [];

    try {
      // MyFirestoreQuerySnapshot querySnapshot = await FirebaseNodes.gamesCollectionReference.get();
      // if(querySnapshot.docs.isNotEmpty){
      //   for (MyFirestoreQueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
      //     if(queryDocumentSnapshot.data().isNotEmpty) {
      //       productList.add(ProductModel.fromMap(queryDocumentSnapshot.data()));
      //     }
      //     else {
      //       MyPrint.printOnConsole("Product Document Empty for Document Id:${queryDocumentSnapshot.id}");
      //     }
      //   }
      // }
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in getProductListRepo in ProductRepository $e');
      MyPrint.printOnConsole(s);
    }

    return clubList;
  }

  Future<void> AddClubRepo(ClubModel clubModel) async {
    // await FirebaseNodes.gameDocumentReference(gameId: gameModel.id).set(gameModel.toMap());
  }
}
