import 'package:club_model/club_model.dart';
import 'package:club_model/models/club/data_model/club_operator_model.dart';

class ClubOperatorRepository {
  Future<List<ClubModel>> getClubOperatorListRepo() async {
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


  Future<void> AddClubOperatorRepo(ClubOperatorModel clubOperatorModel) async {
    await FirebaseNodes.clubOperatorDocumentReference(clubOperatorId: clubOperatorModel.id)
        .set(clubOperatorModel.toMap());
  }

  Future<void> deleteClubOperatorRepo(String operatorId) async {
    await FirebaseNodes.clubOperatorDocumentReference(clubOperatorId: operatorId)
        .delete();
  }

  Future<ClubModel?> checkLoginClubMethod({required String adminId, required String password}) async {
    try {
      ClubModel? clubModel;
      MyPrint.printOnConsole("query id: $adminId password: $password");

      final query = await FirebaseNodes.clubsCollectionReference.where('userId', isEqualTo: adminId).where('password', isEqualTo: password).get();

      MyPrint.printOnConsole("query data: ${query.docs}");

      if (query.docs.isNotEmpty) {
        MyPrint.printOnConsole("doc is Not Empty");
        final doc = query.docs[0];
        MyPrint.printOnConsole("doc is Not Empty ${doc.data()}");
        MyPrint.printOnConsole("doc is Not Empty Inside if");

        clubModel = ClubModel.fromMap(doc.data());
      }
      MyPrint.printOnConsole("query id model: $clubModel");
      return clubModel;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in delete check admin login method in admin Repository $e");
      MyPrint.printOnConsole(s);
    }
    return null;
  }
}
