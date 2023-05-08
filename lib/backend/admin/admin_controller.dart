import 'dart:typed_data';
import 'package:club_app_admin/backend/admin/admin_provider.dart';
import 'package:club_app_admin/backend/admin/admin_repository.dart';
import 'package:club_model/club_model.dart';
import '../../models/admin/property_model.dart';

class AdminController{
  late AdminProvider _adminProvider;
  late AdminRepository _adminRepository;

  AdminController({required AdminProvider? adminProvider,AdminRepository?  repository}){
    _adminProvider =  adminProvider ??  AdminProvider();
    _adminRepository =  repository ??  AdminRepository();
  }

  AdminProvider get adminProvider => _adminProvider;
  AdminRepository get adminRepository => _adminRepository;

  Future<void> getPropertyDataAndSetInProvider() async {
    MyPrint.printOnConsole("AdminController().getPropertyDataAndSetInProvider() called");

    try {
      PropertyModel? propertyModel = await adminRepository.getPropertyData();

      adminProvider.setPropertyModel(propertyModel ?? PropertyModel());
    }
    catch(e) {
      MyPrint.printOnConsole("Error in getting PropertyModel in AdminRepository().getPropertyData():$e",);
    }

    MyPrint.printOnConsole("Final propertyModel:${adminProvider.getPropertyModel(isNewInstance: false)}",);
  }

  Future<void> addBannersToFirebaseAndCloudinary({required Uint8List image}) async {

    try {



      await getPropertyDataAndSetInProvider();
    }catch(e,s){
      MyPrint.printOnConsole('Error in Admin Controller Add Images to the Firebase Method $e');
      MyPrint.printOnConsole(s);
    }

  }


  Future<void> deleteBannersFromFirebaseAndCloudinary({required String imageUrl}) async {

    try {

        await FirebaseNodes.adminPropertyDocumentReference.update({'bannerImages': FieldValue.arrayRemove([imageUrl])});


      await getPropertyDataAndSetInProvider();
    }catch(e,s){
      MyPrint.printOnConsole('Error in Admin Controller Remove Images from the Firebase Method $e');
      MyPrint.printOnConsole(s);
    }
  }



}