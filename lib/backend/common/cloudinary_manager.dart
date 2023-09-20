import 'dart:async';
import 'dart:typed_data';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:club_model/utils/my_print.dart';

import '../../configs/cloudinary_api_keys.dart';

class CloudinaryManager {

  static final CloudinaryManager _instance = CloudinaryManager._();
  factory CloudinaryManager() => _instance;


  late Cloudinary cloudinary;

  CloudinaryManager._() {
    cloudinary = Cloudinary.full(
      apiKey: getCloudinaryApiKey(),
      apiSecret: getCloudinaryApiSecret(),
      cloudName: getCloudinaryCloudName(),
    );
  }

  Future<List<String>> uploadImagesToCloudinary(List<Uint8List> imagesToUpload) async {
    MyPrint.printOnConsole("imagesToUpload length: ${imagesToUpload.length} ");
    List<String> uploadedImages = [];

    if (imagesToUpload.isNotEmpty) {
      int i = 0, maxCount = 0;
      FutureOr<void> whenCompletedCallback() => i++;

    //  Cloudinary cloudinary = Cloudinary(getCloudinaryApiKey(), getCloudinaryApiSecret(), getCloudinaryCloudName());

      for (var element in imagesToUpload) {
        maxCount++;
        cloudinary.uploadResource(CloudinaryUploadResource(
          fileBytes: element,
          resourceType: CloudinaryResourceType.image,
          // fileName: 'asd@asd.com'
        )).then((CloudinaryResponse cloudinaryResponse) {
          if (cloudinaryResponse.isSuccessful) {
            if(cloudinaryResponse.url?.isNotEmpty ?? false) {
              uploadedImages.add(cloudinaryResponse.url!);
              MyPrint.printOnConsole("in uplssoadec ${uploadedImages.length}");
              MyPrint.printOnConsole(' Upload success, url:${cloudinaryResponse.url}');
            }
          }
          else {
            MyPrint.printOnConsole('Error from image repo uploading : ${cloudinaryResponse.error}');
          }

          whenCompletedCallback();
        }).catchError((e) {
          whenCompletedCallback();
        });
      }

      while (i < maxCount) {
        MyPrint.printOnConsole("i in while:$i");
        await Future.delayed(const Duration(milliseconds: 100));
      }

      MyPrint.printOnConsole("in uploassssdec ${uploadedImages.length}");
    }

    return uploadedImages;
  }

  Future<bool> deleteImagesFromCloudinary({required List<String> images}) async {
    if (images.isEmpty) return true;

    //Cloudinary cloudinary = Cloudinary(getCloudinaryApiKey(), getCloudinaryApiSecret(), getCloudinaryCloudName());
    List<Future> futures = [];
    images.forEach((element) {
      futures.add(cloudinary.deleteFile(url: element,).then((value) {
        MyPrint.printOnConsole("$element deleted from cloudinary");
      })
          .catchError((e) {
        MyPrint.printOnConsole("$element couldn't deleted from cloudinary");
      }));
    });

    await Future.wait(futures);

    return true;
  }
}