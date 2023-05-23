import 'package:club_model/configs/constants.dart';
import 'package:club_model/configs/typedefs.dart';
import 'package:club_model/models/common/data_model/property_model.dart';
import 'package:club_model/utils/my_print.dart';

class AdminRepository {
  Future<PropertyModel?> getPropertyData() async {
    MyPrint.printOnConsole("AdminRepository().getPropertyData() called");

    PropertyModel? propertyModel;

    try {
      MyFirestoreDocumentSnapshot snapshot =
          await FirebaseNodes.adminPropertyDocumentReference.get();
      MyPrint.printOnConsole(
        "snapshot exist:${snapshot.exists}",
      );
      MyPrint.printOnConsole(
        "snapshot data:${snapshot.data()}",
      );

      if (snapshot.data() != null && (snapshot.data()?.isNotEmpty ?? false)) {
        propertyModel = PropertyModel.fromMap(snapshot.data()!);
      }
    } catch (e, s) {
      MyPrint.printOnConsole(
        "Error in getting PropertyModel in AdminRepository().getPropertyData():$e",
      );
      MyPrint.printOnConsole(
        s,
      );
    }

    MyPrint.printOnConsole(
      "Final propertyModel:$propertyModel",
    );

    return propertyModel;
  }
}
