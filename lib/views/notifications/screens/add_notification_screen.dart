import 'dart:typed_data';

import 'package:club_model/backend/notification/notification_controller.dart';
import 'package:club_model/backend/notification/notification_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/common/data_model/notication_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../backend/common/cloudinary_manager.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/get_title.dart';
import '../../common/components/header_widget.dart';

class AddNotificationScreen extends StatefulWidget {
  static const String routeName = "/AddNotificationScreen";
  const AddNotificationScreen({Key? key}) : super(key: key);

  @override
  State<AddNotificationScreen> createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {

  final _formKey = GlobalKey<FormState>();

  NotificationModel? pageNotificationModel;


  late NotificationProvider notificationProvider;
  late NotificationController notificationController;
  late Future<void> futureGetData;
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? thumbnailImageUrl;
  Uint8List? thumbnailImage;
  String? thumbnailImageName;

  Future<void> getData() async {}

  Future<void> addThumbnailImage() async {
    setState(() {});
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
      allowCompression: true,
    );

    if (result?.files.firstElement != null) {
      PlatformFile platformFile = result!.files.firstElement!;
      thumbnailImage = platformFile.bytes;

      if (mounted) setState(() {});
    }
  }

  Future<void> addNotification() async {
    setState(() {
      isLoading = true;
    });
    String cloudinaryUploadedImageUrl = '';
    if (thumbnailImage != null) {
      List<String> uploadedImages = [];
      uploadedImages = await CloudinaryManager().uploadImagesToCloudinary([thumbnailImage!]);
      if (uploadedImages.isNotEmpty) {
        cloudinaryUploadedImageUrl = uploadedImages.first;
      }
    }
    pageNotificationModel = NotificationModel(
      id: MyUtils.getNewId(isFromUUuid: false),
      createdTime: Timestamp.now(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      isOpened: false,
    );
    if(pageNotificationModel != null) {
      await notificationController.createNotification(pageNotificationModel!);
    }
    setState(() {
      isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    notificationProvider = context.read<NotificationProvider>();
    notificationController = NotificationController(notificationProvider: notificationProvider);
    futureGetData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureGetData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              progressIndicator: const Center(child: LoadingWidget()),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 28,
                              color: Styles.bgSideMenu,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: HeaderWidget(
                              title: "Add Notification",
                            )),
                      ],
                    ),
                    getMainBody(),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: LoadingWidget());
          }
        });
  }

  Widget getMainBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            CommonText(
                text: "Notification Basic Information",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 20,
            ),
            getTitleAndDescription(),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            CommonText(
                text: " Thumbnail Image",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 10,
            ),
            getAddImageRow(),
            const SizedBox(
              height: 50,
            ),
            getAddNotificationButton(),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget getTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CommonText(
        text: title,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        textAlign: TextAlign.start,
        color: Styles.bgSideMenu,
      ),
    );
  }

  Widget getTitleAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Enter Notification Title*"),
        CommonTextFormField(
          controller: titleController,
          hintText: "Enter Notification Title",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "  Please enter a Notification Title";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        GetTitle(title: "Enter Notification Description*"),
        CommonTextFormField(
          controller: descriptionController,
          hintText: "Enter Notification Description",
          minLines: 3,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "  Please enter a Notification Description";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget getAddImageRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetTitle(title: "Choose Notification Thumbnail Image*"),
              thumbnailImage == null && thumbnailImageUrl == null && (thumbnailImageUrl?.isEmpty ?? true)
                  ? InkWell(
                  onTap: () async {
                    await addThumbnailImage();
                  },
                  child: const EmptyImageViewBox())
                  : CommonImageViewBox(
                imageAsBytes: thumbnailImage,
                url: thumbnailImageUrl,
                rightOnTap: () {
                  thumbnailImage = null;
                  thumbnailImageUrl = null;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getAddNotificationButton() {
    return CommonButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await addNotification();
            Navigator.pop(context);
          }
        },
        text:  "+ Add Notification");
  }


}
