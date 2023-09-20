import 'package:club_app_admin/backend/common/cloudinary_manager.dart';
import 'package:club_model/backend/admin/admin_controller.dart';
import 'package:club_model/backend/admin/admin_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/common/data_model/banner_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/get_title.dart';
import '../../common/components/header_widget.dart';

class AddBannerScreen extends StatefulWidget {
  static const String routeName = "/AddBannerScreen";
  final AddBannerScreenNavigationArguments arguments;
  AddBannerScreen({required this.arguments});

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
  bool isExternal = true;
  TextEditingController externalOnTapUrlController = TextEditingController();
  TextEditingController viewNumberController = TextEditingController();
  TextEditingController screenNameController = TextEditingController();
  String? thumbnailImageUrl;
  Uint8List? thumbnailImage;

  List<String> internalClickType = ['Offer', 'New Launch', 'New Discounts'];

  String? internalClickValue;

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
    setState(() {
      isLoading = true;
    });
    String cloudinaryUploadedImageUrl = '';
    if(pageBannerModel != null && thumbnailImage != null)  {
      List<String> removeImages = [];
      removeImages.add(pageBannerModel!.imageUrl);
      await CloudinaryManager().deleteImagesFromCloudinary(images: removeImages);
      MyPrint.printOnConsole('Image Removed from Cloudinary');
    }
    if (thumbnailImage != null) {
      List<String> uploadedImages = [];
      uploadedImages = await CloudinaryManager().uploadImagesToCloudinary([thumbnailImage!]);
      if (uploadedImages.isNotEmpty) {
        cloudinaryUploadedImageUrl = uploadedImages.first;
      }
    }
    pageBannerModel = BannerModel(
      id: MyUtils.getNewId(isFromUUuid: false),
      createdTime: pageBannerModel != null ? pageBannerModel!.createdTime : Timestamp.now(),
      isInternal: !isExternal,
      viewNumber: ParsingHelper.parseIntMethod(viewNumberController.text),
      externalUrl: isExternal ? externalOnTapUrlController.text.trim() : '',
      imageUrl: cloudinaryUploadedImageUrl,
      internalScreenName: screenNameController.text.trim(),
      internalFeatureType: internalClickValue ?? '',
      updatedTime: pageBannerModel != null ? Timestamp.now() : null,
    );
    await adminController.addBannerToFirebase(bannerModel: pageBannerModel!);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getData() async {
    if (widget.arguments.bannerModel != null) {
      pageBannerModel = widget.arguments.bannerModel;
       externalOnTapUrlController.text = pageBannerModel!.externalUrl;
       viewNumberController.text =  ParsingHelper.parseStringMethod(pageBannerModel!.viewNumber);
       screenNameController.text =  pageBannerModel!.internalScreenName;
       thumbnailImageUrl = pageBannerModel!.imageUrl;
      internalClickValue = pageBannerModel?.internalFeatureType;
      isExternal = !pageBannerModel!.isInternal;
    }
  }

  @override
  void initState() {
    super.initState();
    adminProvider = context.read<AdminProvider>();
    adminController = AdminController(adminProvider : adminProvider);
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
            height: 40,
          ),
          getBannerViewNumber(),
          const SizedBox(
            height: 40,
          ),
          GetTitle(title: "Choose On Click Routing*",fontSize: 20),
          const SizedBox(
            height: 5,
          ),
          getInternalExternalLink(),
          const SizedBox(
            height: 80,
          ),
          getAddBannerButton(),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    ));
  }

  Widget getBannerViewNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Enter View Number in List(ex. 1,2,3...)*",fontSize: 20),
        const SizedBox(
          height: 5,
        ),
        CommonTextFormField(
          controller: viewNumberController,
          hintText: "Enter View Number in List",
          cursorColor: Colors.black,
          textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty || value == "0") {
              return "  Please Enter View Number in List except zero";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget getBannerImage() {
    return  Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetTitle(title: "Choose Banner Image*",fontSize: 20),
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
        CommonText(text: 'External : ',fontSize: 16,fontWeight: FontWeight.normal),
        SizedBox(width: 10,),
        getTestEnableSwitch(value: isExternal,
         onChanged: (bool? val){
          setState(() {
            isExternal = val ?? true;
          });
         }
        ),
        SizedBox(width: 30,),
        isExternal
            ? Expanded(
                child: CommonTextFormField(
                  controller: externalOnTapUrlController,
                  hintText: "Enter External Banner Click Url",
                  validator: null,
                ),
              )
            : Expanded(child: getInternalWidget())
      ],
    );
  }

  Widget getAddBannerButton() {
    return CommonButton(
        onTap: () async {
          if(_formKey.currentState!.validate()) {
            if (thumbnailImage == null && thumbnailImageUrl.checkEmpty) {
              MyToast.showError(context: context, msg: 'Please upload a banner image');
              return;
            }

            if (isExternal) {
              if (externalOnTapUrlController.text.isEmpty) {
                MyToast.showError(context: context, msg: 'Please Enter an external click URL');
                return;
              }
            }else{
              if(internalClickValue == null){
                MyToast.showError(context: context, msg: 'Please Enter type of banner for internal routing click');
                return;
              }
              if (screenNameController.text.isEmpty) {
                MyToast.showError(context: context, msg: 'Please Enter screen name for internal routing click');
                return;
              }
            }

            await addBanner();
            if (context.mounted && context.checkMounted()) {
              Navigator.pop(context);
            }
          }
        },
        text: "+ Add Banner");
  }

  Widget getTestEnableSwitch({required bool value, void Function(bool?)? onChanged}) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Styles.bgSideMenu,
    );
  }

  Widget getInternalWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 1, color: Styles.bgSideMenu),
          ),
          child: DropdownButton<String>(
            value: internalClickValue,
            style: TextStyle(
              color: Styles.bgSideMenu,
              fontSize: 18,
            ),
            dropdownColor: Colors.white,
            underline: Container(),
            iconEnabledColor: Colors.black,
            isExpanded: true,
            hint: CommonText(
              text: 'Select Internal Click Type',
            ),
            borderRadius: BorderRadius.circular(4),
            items: internalClickType.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (val) async {
              //await changeStatus(currentProductName: val);
              if (val is String) {
                internalClickValue = val;
                setState(() {});
              }
            },
          ),
        ),
        SizedBox(height: 15,),
        CommonTextFormField(
          controller: screenNameController,
          hintText: "Enter Internal Screen Name",
          validator: null,
        ),
      ],
    );
  }
}
