import 'dart:typed_data';

import 'package:club_app_admin/backend/brands_backend/brand_controller.dart';
import 'package:club_app_admin/backend/brands_backend/brand_provider.dart';
import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/get_title.dart';
import '../../common/components/header_widget.dart';

class AddBrand extends StatefulWidget {
  static const String routeName = "/AddBrand";
  final AddBrandScreenNavigationArguments arguments;
  AddBrand({required this.arguments});

  @override
  State<AddBrand> createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  final _formKey = GlobalKey<FormState>();

  BrandModel? pageBrandModel;

  late BrandProvider brandProvider;
  late BrandController brandController;
  late Future<void> futureGetData;

  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  String? thumbnailImageUrl;
  Uint8List? thumbnailImage;
  String? thumbnailImageName;

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
      thumbnailImageName = platformFile.name;

      if (mounted) setState(() {});
    }
  }

  Future<void> addBrandThumbnailImage() async {
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

  Future<String?> uploadFileToFirebaseStorage({
    required String brandId,
    required String imageName,
  }) async {
    String? firebaseStorageImageUrl;
    String finalFileName = MyUtils().getStorageUploadImageUrl(nativeImageName: imageName);
    if (thumbnailImage != null) {
      firebaseStorageImageUrl =
      await FireBaseStorageController().uploadBrandImagesToFireBaseStorage(
          data: thumbnailImage!,
          brandId: brandId,
          fileName: finalFileName,
      );
      MyPrint.printOnConsole("Method after await");
    }
    return firebaseStorageImageUrl;
  }

  Future<void> getData() async {
    MyPrint.printOnConsole('is edit is ${widget.arguments.isEdit}');
    if (widget.arguments.brandModel != null) {
      pageBrandModel = widget.arguments.brandModel;
    }

    if (pageBrandModel != null) {
      nameController.text = pageBrandModel!.name;
      thumbnailImageUrl = pageBrandModel!.thumbnailImageUrl;
    }
  }

  Future<void> submitBrand() async {
    setState(() {
      isLoading = true;
    });

    String brandId = pageBrandModel?.id ?? "";
    if (brandId.isEmpty) {
      brandId = MyUtils.getNewId(isFromUUuid: false);
    }

    if (thumbnailImageName != null) {
      thumbnailImageUrl = await uploadFileToFirebaseStorage(brandId: brandId, imageName: thumbnailImageName!);
    }

    if (thumbnailImageUrl == null) {
      // ignore: use_build_context_synchronously
      MyToast.showError(context: context, msg: 'There is some issue in uploading brand Image. Kindly try again!');
      return;
    }

    BrandModel brandModel = BrandModel(
      id: brandId.trim(),
      name: nameController.text.trim(),
      thumbnailImageUrl: thumbnailImageUrl!.trim(),
      createdTime: pageBrandModel?.createdTime ?? Timestamp.now(),
      updatedTime: pageBrandModel != null ? Timestamp.now() : null,
    );

    await brandController.AddBrandToFirebase(brandModel,
        isAdInProvider: pageBrandModel == null
    );

    if(pageBrandModel != null) {
      BrandModel model = brandModel;
      model.name = brandModel.name;
      model.createdTime = brandModel.createdTime;
      model.updatedTime = brandModel.updatedTime;
      model.thumbnailImageUrl = brandModel.thumbnailImageUrl;
    }

    setState(() {
      isLoading = false;
    });

    MyToast.showSuccess(context: context, msg: pageBrandModel == null ? 'Brand Added Successfully' : 'Brand Edited Successfully');

  }

  @override
  void initState() {
    super.initState();
    brandProvider = Provider.of<BrandProvider>(context, listen: false);
    brandController = BrandController(brandProvider: brandProvider);
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
                              title: "Add Brand",
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
                text: "Brand Basic Information",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 20,
            ),
            getNameAndBrandName(),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            CommonText(
                text: " Image",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 10,
            ),
            getAddImageRow(),
            const SizedBox(
              height: 40,
            ),
            getAddProductButton(),
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
        fontSize: 15,
        textAlign: TextAlign.start,
        color: Styles.bgSideMenu,
      ),
    );
  }

  Widget getNameAndBrandName() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Enter Brand Name*"),
              CommonTextFormField(
                controller: nameController,
                hintText: "Enter Brand Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter a Brand Name";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(),
        )
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
              GetTitle(title: "Choose Brand Thumbnail Image*"),
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

  Widget getAddProductButton() {
    return CommonButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (pageBrandModel == null && thumbnailImage == null) {
              MyToast.showError(
                  context: context,
                  msg: 'Please upload a brand thumbnail image');
              return;
            }
            if (pageBrandModel != null  && (thumbnailImageUrl.checkEmpty && thumbnailImage == null)) {
              MyToast.showError(
                  context: context,
                  msg: 'Please upload a brand thumbnail image');
              return;
            }
            await submitBrand();
            Navigator.pop(context);
          }
        },
        text: pageBrandModel == null ? "+ Add Brand" : 'Edit Brand');
  }
}
