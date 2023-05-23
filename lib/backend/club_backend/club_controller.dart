import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/backend/club_backend/club_repository.dart';
import 'package:club_app_admin/configs/constants.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/utils/my_print.dart';

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

  Future<void> EnableDisableClubInFirebase({
    required Map<String, dynamic> editableData,
    required String id,
    required int listIndex,
    required bool isAdminEnabled,
  }) async {
    try {
      await FirebaseNodes.clubDocumentReference(clubId: id)
          .update(editableData)
          .then((value) {
        MyPrint.printOnConsole(
            "user data: ${(isAdminEnabled ? editableData[MyAppConstants.cAdminEnabled] : editableData[MyAppConstants.cClubEnabled])}");
        isAdminEnabled
            ? clubProvider.updateEnableDisableOfAdminInList(
                editableData[MyAppConstants.cAdminEnabled], listIndex)
            : clubProvider.updateEnableDisableOfClubInList(
                editableData[MyAppConstants.cClubEnabled], listIndex);
      });
    } catch (e, s) {
      MyPrint.printOnConsole(
          "Error in Enable Disable Club in firebase in Club Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> AddClubToFirebase(ClubModel clubModel) async {
    try {
      await clubRepository.AddClubRepo(clubModel);
      clubProvider.addClubModelInClubList(clubModel);
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in Add Club to Firebase in Club Controller $e');
      MyPrint.printOnConsole(s);
    }
  }
}
