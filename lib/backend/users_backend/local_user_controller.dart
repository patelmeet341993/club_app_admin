import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app_admin/backend/users_backend/local_user_repository.dart';
import 'package:club_app_admin/backend/users_backend/user_provider.dart';
import 'package:club_model/configs/constants.dart';
import 'package:club_model/models/user/data_model/user_model.dart';
import 'package:club_model/utils/my_print.dart';

import '../../configs/constants.dart';

class LocalUserController{
  late UserProvider userProvider;
  late LocalUserRepository userRepository;

  LocalUserController({required this.userProvider,LocalUserRepository?  repository}){
   userRepository =  repository ??  LocalUserRepository();
  }

  Future<void> getAllUsersFromFirebase({bool isRefresh = true,bool isNotify = true}) async {

    try{
      MyPrint.printOnConsole("In Side The Method");

      if(!isRefresh && userProvider.usersListLength > 0) {
        MyPrint.printOnConsole("Returning Cached Data");
        userProvider.usersList;
      }

      if (isRefresh) {
        MyPrint.printOnConsole("Refresh");
        userProvider.setHasMoreUsers = true; // flag for more products available or not
        userProvider.setLastDocument = null; // flag for last document from where next 10 records to be fetched
        userProvider.setIsUsersLoading(false, isNotify: isNotify);
        userProvider.setUsersList([], isNotify: isNotify);
      }

      if (!userProvider.getHasMoreUsers) {
        MyPrint.printOnConsole('No More Users');
        return;
      }
      if (userProvider.getIsUsersLoading)  return;

      userProvider.setIsUsersLoading(true, isNotify: isNotify);

      Query<Map<String, dynamic>> query = FirebaseNodes.usersCollectionReference
          .limit(MyAppConstants.userDocumentLimitForPagination)
          .orderBy("createdTime", descending: true).where('adminEnabled',isEqualTo: true);

      //For Last Document
      DocumentSnapshot<Map<String, dynamic>>? snapshot = userProvider.getLastDocument;
      if(snapshot != null) {
        MyPrint.printOnConsole("LastDocument not null");
        query = query.startAfterDocument(snapshot);
      }
      else {
        MyPrint.printOnConsole("LastDocument null");
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Documents Length in Firestore for Admin Users:${querySnapshot.docs.length}");

      if (querySnapshot.docs.length < MyAppConstants.userDocumentLimitForPagination) userProvider.setHasMoreUsers = false;

      if(querySnapshot.docs.isNotEmpty) userProvider.setLastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      List<UserModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        if((documentSnapshot.data() ?? {}).isNotEmpty) {
          UserModel userModel = UserModel.fromMap(documentSnapshot.data()!);
          list.add(userModel);
        }
      }
      userProvider.addAllUsersList(list, isNotify: false);
      userProvider.setIsUsersLoading(false);
      MyPrint.printOnConsole("Final User Length From Firestore:${list.length}");
      MyPrint.printOnConsole("Final User Length in Provider:${userProvider.usersListLength}");



    }catch(e,s){
      MyPrint.printOnConsole("Error in get User List form Firebase in user Controller $e");
      MyPrint.printOnConsole(s);
    }

  }

  Future<void> getAllDisabledUsersFromFirebase({bool isRefresh = true,bool isNotify = true}) async {

    try{
      MyPrint.printOnConsole("In Side The Method");

      if(!isRefresh && userProvider.disabledUsersListLength > 0) {
        MyPrint.printOnConsole("Returning Cached Data");
        userProvider.disabledUsersList;
      }

      if (isRefresh) {
        MyPrint.printOnConsole("Refresh");
        userProvider.setHasMoreDisabledUsers = true; // flag for more products available or not
        userProvider.setDisabledUsersLastDocument = null; // flag for last document from where next 10 records to be fetched
        userProvider.setIsDisabledUsersLoading(false, isNotify: isNotify);
        userProvider.setDisabledUsersList([], isNotify: isNotify);
      }

      if (!userProvider.getHasMoreDisabledUsers) {
        MyPrint.printOnConsole('No More Users');
        return;
      }
      if (userProvider.getIsDisabledUsersLoading)  return;

      userProvider.setIsDisabledUsersLoading(true, isNotify: isNotify);

      Query<Map<String, dynamic>> query = FirebaseNodes.usersCollectionReference
          .limit(MyAppConstants.userDocumentLimitForPagination)
          .orderBy("createdTime", descending: true).where('adminEnabled',isEqualTo: false);

      //For Last Document
      DocumentSnapshot<Map<String, dynamic>>? snapshot = userProvider.getDisabledUsersLastDocument;
      if(snapshot != null) {
        MyPrint.printOnConsole("LastDocument not null");
        query = query.startAfterDocument(snapshot);
      }
      else {
        MyPrint.printOnConsole("LastDocument null");
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Documents Length in Firestore for Admin Users:${querySnapshot.docs.length}");

      if (querySnapshot.docs.length < MyAppConstants.userDocumentLimitForPagination) userProvider.setHasMoreDisabledUsers = false;

      if(querySnapshot.docs.isNotEmpty) userProvider.setDisabledUsersLastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      List<UserModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        if((documentSnapshot.data() ?? {}).isNotEmpty) {
          UserModel userModel = UserModel.fromMap(documentSnapshot.data()!);
          list.add(userModel);
        }
      }
      userProvider.addAllDisabledUsersList(list, isNotify: false);
      userProvider.setIsDisabledUsersLoading(false);
      MyPrint.printOnConsole("Final User Length From Firestore:${list.length}");
      MyPrint.printOnConsole("Final User Length in Provider:${userProvider.disabledUsersListLength}");

    }catch(e,s){
      MyPrint.printOnConsole("Error in get Disabled User List form Firebase in user Controller $e");
      MyPrint.printOnConsole(s);
    }

  }

  Future<void> EnableDisableUserInFirebase({required Map<String,dynamic> editableData,required String id,required int listIndex}) async {
    try{
      await FirebaseNodes.userDocumentReference(userId: id)
          .update(editableData).then((value) {
        MyPrint.printOnConsole("user data: ${editableData["adminEnabled"]}");
        userProvider.updateEnableDisableOfList(editableData["adminEnabled"] , listIndex);
      });
    }catch(e,s){
      MyPrint.printOnConsole("Error in Enable Disable User in firebase in User Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> EnableDisableDisabledUserInFirebase({required Map<String,dynamic> editableData,required String id,required int listIndex}) async {
    try{
      await FirebaseNodes.userDocumentReference(userId: id)
          .update(editableData).then((value) {
        MyPrint.printOnConsole("user data: ${editableData["adminEnabled"]}");
        userProvider.updateEnableDisableDisabledOfList(editableData["adminEnabled"] , listIndex);
      });
    }catch(e,s){
      MyPrint.printOnConsole("Error in Enable Disable User in firebase in User Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

}