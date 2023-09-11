


import 'dart:typed_data';

import 'package:club_app_admin/backend/admin/admin_controller.dart';
import 'package:club_app_admin/backend/admin/admin_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/common/data_model/banner_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/get_title.dart';
import '../../common/components/header_widget.dart';

class AddBannerScreen extends StatefulWidget {
  static const String routeName = "/AddBannerScreen";

  const AddBannerScreen({Key? key}) : super(key: key);

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {

  final _formKey = GlobalKey<FormState>();

  BannerModel? pageBannerModel;

  late AdminProvider adminProvider;
  late AdminController adminController;
  late Future<void> futureGetData;
  bool isLoading = false;
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController onTapUrlController = TextEditingController();
  String? thumbnailImageUrl;
  Uint8List? thumbnailImage;


  final ImagePicker _picker = ImagePicker();

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

  Future<void> addBanner() async {

  }


  Future<void> getData() async {

  }




  @override
  void initState() {
    super.initState();
    adminProvider = context.read<AdminProvider>();
    adminController = AdminController(adminProvider: adminProvider);
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
                              title: "Add Banner",
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
    return Expanded(child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          getBannerImage(),
          const SizedBox(
            height: 30,
          ),
          GetTitle(title: "Choose On Click Routing*"),
          const SizedBox(
            height: 30,
          ),

          const SizedBox(
            height: 30,
          ),
          getAddProductButton(),
          const SizedBox(
            height: 40,
          ),





        ],
      ),
    ));
  }

  Widget getBannerImage() {
    return  Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetTitle(title: "Choose Banner Image*"),
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

  Widget getInternalExternalLink() {
    return Row(
      children: [

      ],
    );
  }


  Widget getAddProductButton() {
    return CommonButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (thumbnailImage == null && thumbnailImageUrl.checkEmpty) {
              MyToast.showError(context: context, msg: 'Please upload a product thumbnail image');
              return;
            }
            await addBanner();
            if (context.mounted && context.checkMounted()) {
              Navigator.pop(context);
            }
          }
        },
        text: "+ Add Banner");
  }

}
