import 'dart:typed_data';

import 'package:club_app_admin/backend/club_operator_backend/club_operator_provider.dart';
import 'package:club_app_admin/backend/club_operator_backend/club_operator_repository.dart';
import 'package:club_app_admin/configs/constants.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/club/data_model/club_operator_model.dart';
import 'package:club_model/utils/my_print.dart';
import 'package:image_picker/image_picker.dart';

class ClubOperatorController {
  late ClubOperatorProvider clubOperatorProvider;
  late ClubOperatorRepository clubOperatorRepository;

  ClubOperatorController({required this.clubOperatorProvider, ClubOperatorRepository? repository}) {
    clubOperatorRepository = repository ?? ClubOperatorRepository();
  }


  Future<void> getClubOperatorFromFirebase({bool isRefresh = true, bool isNotify = true}) async {
    try {

      if (!isRefresh && clubOperatorProvider.clubOperatorList.length > 0) {
        MyPrint.printOnConsole("Returning Cached Data");
        clubOperatorProvider.clubOperatorList;
      }

      if (isRefresh) {
        MyPrint.printOnConsole("Refresh");
        clubOperatorProvider.hasMoreClubOperators.set(value: true,isNotify: isNotify); // flag for more products available or not
        clubOperatorProvider.lastDocument.set(value: null,isNotify: false); // flag for last document from where next 10 records to be fetched
        clubOperatorProvider.clubOperatorsLoading.set(value: false, isNotify: false);
        clubOperatorProvider.clubOperatorList.setList(list: [], isNotify: isNotify);
      }

      if (!clubOperatorProvider.hasMoreClubOperators.get()) {
        MyPrint.printOnConsole('No More Club Operators');
        return;
      }
      if (clubOperatorProvider.clubOperatorsLoading.get()) return;

      clubOperatorProvider.clubOperatorsLoading.set(value: true, isNotify: isNotify);

      Query<Map<String, dynamic>> query = FirebaseNodes.clubOperatorCollectionReference
          .limit(MyAppConstants.clubOperatorDocumentLimitForPagination)
          .orderBy("createdTime", descending: true);

      //For Last Document
      DocumentSnapshot<Map<String, dynamic>>? snapshot = clubOperatorProvider.lastDocument.get();
      if (snapshot != null) {
        MyPrint.printOnConsole("LastDocument not null");
        query = query.startAfterDocument(snapshot);
      } else {
        MyPrint.printOnConsole("LastDocument null");
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Documents Length in FireStore for Club Operator : ${querySnapshot.docs.length}");

      if (querySnapshot.docs.length < MyAppConstants.clubOperatorDocumentLimitForPagination) clubOperatorProvider.hasMoreClubOperators.set(value: false);

      if (querySnapshot.docs.isNotEmpty) clubOperatorProvider.lastDocument.set(value:querySnapshot.docs[querySnapshot.docs.length - 1]);

      List<ClubOperatorModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        if ((documentSnapshot.data() ?? {}).isNotEmpty) {
          ClubOperatorModel clubOperatorModel = ClubOperatorModel.fromMap(documentSnapshot.data()!);
          list.add(clubOperatorModel);
        }
      }
      clubOperatorProvider.addAllClubOperatorList(list, isNotify: false);
      clubOperatorProvider.clubOperatorsLoading.set(value: false);
      MyPrint.printOnConsole("Final Club Operator Length From FireStore :${list.length}");
      MyPrint.printOnConsole("Final Club Operator Length in Provider:${clubOperatorProvider.clubOperatorList.length}");
    } catch (e, s) {
      MyPrint.printOnConsole("Error in get Club Operator List form Firebase in Club Operator Controller $e");
      MyPrint.printOnConsole(s);
    }
  }


  Future<void> EnableDisableClubOperatorInFirebase({
    required bool adminEnabled,
    required String id,
    required ClubOperatorModel model,
  }) async {
    try {
      Map<String, dynamic> data = {
        MyAppConstants.cAdminEnabled: adminEnabled,
      };
      await FirebaseNodes.clubOperatorDocumentReference(clubOperatorId: id)
          .update(data);
      model.adminEnabled = adminEnabled;

    } catch (e, s) {
      MyPrint.printOnConsole(
          "Error in Enable Disable Club Operator in firebase in Club Operator Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> addClubOperatorToFirebase(ClubOperatorModel clubOperatorModel,{bool isEdit = false}) async {
    try {
      await clubOperatorRepository.AddClubOperatorRepo(clubOperatorModel);
      if(!isEdit) clubOperatorProvider.clubOperatorList.insertAtIndex(index: 0, model: clubOperatorModel);
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in Add Club Operator to Firebase in Club Controller $e');
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> deleteClubOperatorFromFirebase(ClubOperatorModel clubOperatorModel) async {
    try {
      await clubOperatorRepository.deleteClubOperatorRepo(clubOperatorModel);
      clubOperatorProvider.clubOperatorList.removeObject(model: clubOperatorModel);
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in Add Club to Firebase in Club Controller $e');
      MyPrint.printOnConsole(s);
    }
  }

  // Future<void> AddClubUserToFirebase(ClubUserModel clubModel) async {
  //   try {
  //     await clubRepository.AddClubUserRepo(clubModel);
  //     clubProvider.addClubUserModelInClubUserList(clubModel);
  //   } catch (e, s) {
  //     MyPrint.printOnConsole(
  //         'Error in Add Club to Firebase in Club Controller $e');
  //     MyPrint.printOnConsole(s);
  //   }
  // }

  Future<String> uploadImageToFirebase(XFile imageFile, {String clubId = ""}) async {
    String imageUrl = "";

    try {
      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Uint8List? imageData  = await imageFile.readAsBytes();
      String type = imageFile.mimeType?.split("/").last ?? "";
      // Reference the Firebase Storage location to upload the file
      String path = clubId.isEmpty ? "ClubImages/$fileName.$type" : "ClubImages/$clubId/$fileName.$type";
      Reference storageReference = FirebaseStorage.instance.ref().child(path);


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
