import 'package:club_model/club_model.dart';
import 'package:club_model/models/club/data_model/club_user_model.dart';

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

  Future<List<ClubUserModel>> getClubUserListRepo() async {
    List<ClubUserModel> clubUserList = [];

    try {
      MyFirestoreQuerySnapshot querySnapshot =
          await FirebaseNodes.clubUserCollectionReference.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (MyFirestoreQueryDocumentSnapshot queryDocumentSnapshot
            in querySnapshot.docs) {
          if (queryDocumentSnapshot.data().isNotEmpty) {
            clubUserList.add(ClubUserModel.fromMap(queryDocumentSnapshot.data()));
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

    return clubUserList;
  }

  Future<void> AddClubRepo(ClubModel clubModel) async {
    await FirebaseNodes.clubDocumentReference(clubId: clubModel.id)
        .set(clubModel.toMap());
  }

  Future<void> deleteClubRepo(ClubModel clubModel) async {
    await FirebaseNodes.clubDocumentReference(clubId: clubModel.id)
        .delete();
  }
  Future<void> AddClubUserRepo(ClubUserModel clubModel) async {
    await FirebaseNodes.clubUserDocumentReference(clubId: clubModel.id)
        .set(clubModel.toMap());
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
