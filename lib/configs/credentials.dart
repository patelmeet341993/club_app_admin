import 'package:club_model/club_model.dart';

import 'firebase_options_dev.dart' as firebase_dev;
import 'firebase_options_prod.dart' as firebase_prod;

//Firebase credentials
FirebaseOptions getFirebaseOptions({required bool isDev}) => isDev
    ? firebase_dev.DefaultFirebaseOptions.currentPlatform
    : firebase_prod.DefaultFirebaseOptions.currentPlatform;

const String PROJECT_ID_DEV = "club-app-dev-7e7c7";
const String PROJECT_ID_PROD = "club-app-d8d29";
String getProjectId() => AppController.isDev ? PROJECT_ID_DEV : PROJECT_ID_PROD;
