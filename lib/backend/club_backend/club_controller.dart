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

  Future<void> getClubList() async {
    List<ClubModel> clubList = [];
    clubList = await clubRepository.getClubListRepo();
    if (clubList.isNotEmpty) {
      clubProvider.setClubList(clubList);
    }
  }

  // Future<void> getClubUserList() async {
  //   List<ClubUserModel> clubList = [];
  //   clubList = await clubRepository.getClubUserListRepo();
  //   if (clubList.isNotEmpty) {
  //     clubProvider.setClubUserList(clubList);
  //   }
  // }

  Future<void> EnableDisableClubInFirebase({
    required Map<String, dynamic> editableData,
    required String id,
    required int listIndex,
  }) async {
    try {
      await FirebaseNodes.clubDocumentReference(clubId: id)
          .update(editableData)
          .then((value) {
        clubProvider.updateEnableDisableOfAdminInList(
                editableData[MyAppConstants.cAdminEnabled], listIndex);
      });
    } catch (e, s) {
      MyPrint.printOnConsole(
          "Error in Enable Disable Club in firebase in Club Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> AddClubToFirebase(ClubModel clubModel,{bool isEdit = false}) async {
    try {
      await clubRepository.AddClubRepo(clubModel);
      if(!isEdit) clubProvider.addClubModelInClubList(clubModel) ;
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in Add Club to Firebase in Club Controller $e');
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> deleteClubFromFirebase(ClubModel clubModel,int index) async {
    try {
      await clubRepository.deleteClubRepo(clubModel);
      clubProvider.removeClubModelFromClubList(index);
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
