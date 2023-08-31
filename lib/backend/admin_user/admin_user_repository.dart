import 'package:club_model/club_model.dart';

class AdminUserRepository {
  Future<AdminUserModel?> checkLoginAdminMethod({required String adminId, required String password}) async {
    try {
      AdminUserModel? adminModel;
      MyPrint.printOnConsole("query id: $adminId password: $password");

      final query = await FirebaseNodes.adminUsersCollectionReference.where('adminId', isEqualTo: adminId).where('password', isEqualTo: password).get();

      MyPrint.printOnConsole("query data: ${query.docs}");

      if (query.docs.isNotEmpty) {
        MyPrint.printOnConsole("doc is Not Empty");
        final doc = query.docs[0];
        MyPrint.printOnConsole("doc is Not Empty ${doc.data()}");
        MyPrint.printOnConsole("doc is Not Empty Inside if");

        adminModel = AdminUserModel.fromMap(doc.data());
      }
      MyPrint.printOnConsole("query id model: $adminModel");
      return adminModel;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in delete check admin login method in admin Repository $e");
      MyPrint.printOnConsole(s);
    }
    return null;
  }

  Future<void> addNewAdminToFirebase({required AdminUserModel adminModel}) async {
    try {
      MyPrint.printOnConsole("Doc id : ${adminModel.adminId}");

      await FirestoreController.firestore.collection('admin_users').doc(adminModel.adminId).set(adminModel.toMap());

      MyPrint.printOnConsole("Admin Added");
    } catch (e, s) {
      MyPrint.printOnConsole("Error in add new admin in Admin Controller $e");
      MyPrint.printOnConsole(s);
    }
  }
}
