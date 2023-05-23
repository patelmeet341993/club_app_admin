import 'package:club_model/club_model.dart';

class ClubRepository {
  Future<List<ClubModel>> getClubListRepo() async {
    List<ClubModel> clubList = [];

    try {
      MyFirestoreQuerySnapshot querySnapshot =
          await FirebaseNodes.clubsCollectionReference.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (MyFirestoreQueryDocumentSnapshot queryDocumentSnapshot
            in querySnapshot.docs) {
          if (queryDocumentSnapshot.data().isNotEmpty) {
            clubList.add(ClubModel.fromMap(queryDocumentSnapshot.data()));
          } else {
            MyPrint.printOnConsole(
                "Club Document Empty for Document Id:${queryDocumentSnapshot.id}");
          }
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole('Error in getClubListRepo in ClubRepository $e');
      MyPrint.printOnConsole(s);
    }

    return clubList;
  }

  Future<void> AddClubRepo(ClubModel clubModel) async {
    await FirebaseNodes.clubDocumentReference(clubId: clubModel.id)
        .set(clubModel.toMap());
  }
}
