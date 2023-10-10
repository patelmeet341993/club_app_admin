import 'dart:typed_data';

import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/backend/club_backend/club_repository.dart';
import 'package:club_app_admin/configs/constants.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/utils/my_print.dart';
import 'package:image_picker/image_picker.dart';

class ClubController {
  late ClubProvider clubProvider;
  late ClubRepository clubRepository;

  ClubController({required this.clubProvider, ClubRepository? repository}) {
    clubRepository = repository ?? ClubRepository();
  }

  Future<void> getClubList({bool isRefresh = true, bool isNotify = true}) async {
    try {

      if (!isRefresh && clubProvider.clubList.length > 0) {
        MyPrint.printOnConsole("Returning Cached Data");
        clubProvider.clubList;
      }

      if (isRefresh) {
        MyPrint.printOnConsole("Refresh");
        clubProvider.hasMoreClub.set(value: true,isNotify: isNotify); // flag for more products available or not
        clubProvider.lastDocument.set(value: null,isNotify: false); // flag for last document from where next 10 records to be fetched
        clubProvider.clubLoading.set(value: false, isNotify: false);
        clubProvider.clubList.setList(list: [], isNotify: isNotify);
      }

      if (!clubProvider.hasMoreClub.get()) {
        MyPrint.printOnConsole('No More Club Operators');
        return;
      }
      if (clubProvider.clubLoading.get()) return;

      clubProvider.clubLoading.set(value: true, isNotify: isNotify);

      Query<Map<String, dynamic>> query = FirebaseNodes.clubsCollectionReference
          .limit(MyAppConstants.clubDocumentLimitForPagination)
          .orderBy("createdTime", descending: true);

      //For Last Document
      DocumentSnapshot<Map<String, dynamic>>? snapshot = clubProvider.lastDocument.get();
      if (snapshot != null) {
        MyPrint.printOnConsole("LastDocument not null");
        query = query.startAfterDocument(snapshot);
      } else {
        MyPrint.printOnConsole("LastDocument null");
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Documents Length in FireStore for Club Operator : ${querySnapshot.docs.length}");

      if (querySnapshot.docs.length < MyAppConstants.clubOperatorDocumentLimitForPagination) clubProvider.hasMoreClub.set(value: false);

      if (querySnapshot.docs.isNotEmpty) clubProvider.lastDocument.set(value:querySnapshot.docs[querySnapshot.docs.length - 1]);

      List<ClubModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        if ((documentSnapshot.data() ?? {}).isNotEmpty) {
          ClubModel clubModel = ClubModel.fromMap(documentSnapshot.data()!);
          list.add(clubModel);
        }
      }
      clubProvider.addAllClubList(list, isNotify: false);
      clubProvider.clubLoading.set(value: false);
      MyPrint.printOnConsole("Final Club Length From FireStore :${list.length}");
      MyPrint.printOnConsole("Final Club Length in Provider:${clubProvider.clubList.length}");
    } catch (e, s) {
      MyPrint.printOnConsole("Error in get Club List form Firebase in Club Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> EnableDisableClubInFirebase({
    required bool adminEnabled,
    required String id,
    ClubModel? model,
  }) async {
    try {
      Map<String, dynamic> data = {
        MyAppConstants.cAdminEnabled: adminEnabled,
      };
      await FirebaseNodes.clubDocumentReference(clubId: id)
          .update(data);
      model?.adminEnabled = adminEnabled;

    } catch (e, s) {
      MyPrint.printOnConsole(
          "Error in Enable Disable Club in firebase in Club Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> AddClubToFirebase(ClubModel clubModel,{bool isEdit = false}) async {
    try {
      await clubRepository.AddClubRepo(clubModel);
      if(!isEdit) clubProvider.clubList.insertAtIndex(index: 0, model: clubModel);
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in Add Club to Firebase in Club Controller $e');
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> deleteClubFromFirebase(ClubModel clubModel) async {
    try {
      await clubRepository.deleteClubRepo(clubModel);
      clubProvider.clubList.removeObject(model: clubModel);
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in Remove Club From Firebase in Club Controller $e');
      MyPrint.printOnConsole(s);
    }
  }

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
