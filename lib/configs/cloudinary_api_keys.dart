


final String devApiKey = "817459273518225";
final String devApiSecret = "iSUjDtVzaUZAfPObejBMOtsW4J0";
final String devCloudName = "dzarwavi8";


String getCloudinaryApiKey() {
  return devApiKey;
 // return prodApiKey;
  // return AppController().isDev ? devApiKey : prodApiKey;
}

String getCloudinaryApiSecret() {
  return devApiSecret;
  //return prodApiSecret;
  // return AppController().isDev ? devApiSecret : prodApiSecret;
}

String getCloudinaryCloudName() {
   return devCloudName;
  //return prodCloudName;
  // return AppController().isDev ? devCloudName : prodCloudName;
}