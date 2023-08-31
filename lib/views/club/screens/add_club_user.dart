import 'dart:typed_data';

import 'package:club_app_admin/backend/club_backend/club_controller.dart';
import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/configs/styles.dart';
import 'package:club_model/models/club/data_model/club_user_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:club_model/view/common/components/loading_widget.dart';
import 'package:club_model/view/common/components/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../backend/products_backend/product_controller.dart';
import '../../../configs/constants.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/header_widget.dart';

class AddClubUser extends StatefulWidget {
  static const String routeName = "/AddClubUser";
  final ClubModel? clubModel;
  final bool isEdit;
  final int? index;

  const AddClubUser({super.key, this.clubModel, this.isEdit = false, this.index});

  @override
  State<AddClubUser> createState() => _AddClubUserState();
}

class _AddClubUserState extends State<AddClubUser> {
  final _formKey = GlobalKey<FormState>();
  late Future<void> futureGetData;
  bool isLoading = false;

  late ClubProvider clubProvider;
  late ClubController clubController;

  TextEditingController clubNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController clubAddressController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String thumbnailImageUrl = '';
  XFile? thumbnailImageFile;
  Uint8List? thumbnailImage;
  final ImagePicker _picker = ImagePicker();

  bool isClubEnabled = true;
  bool isAdminEnabled = true;

  Future<void> addThumbnailImage() async {
    setState(() {});
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      thumbnailImageFile = file;
      thumbnailImage = await file.readAsBytes();
      MyPrint.printOnConsole("Mime type: ${file.mimeType}");
    }
    if (mounted) setState(() {});
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.image,
    //   allowMultiple: false,
    //   withData: true,
    //   allowCompression: true,
    // );
    //
    // if (result?.files.firstElement != null) {
    //   PlatformFile platformFile = result!.files.firstElement!;
    //   thumbnailImage = platformFile.bytes;
    //
    //   if (mounted) setState(() {});
    // }
  }

  Future<void> addClub() async {
    setState(() {
      isLoading = true;
    });
    ClubProvider clubProvider = Provider.of(context, listen: false);
    ClubModel loggedInClubModel = clubProvider.getLoggedInClubModel();

    String newId = MyUtils.getNewId(isFromUUuid: false);
    if (thumbnailImageFile != null) {
      thumbnailImageUrl = await clubController.uploadImageToFirebase(thumbnailImageFile!);
    }

    if (widget.clubModel != null && widget.index != null && widget.isEdit == true) {
      MyPrint.printOnConsole("test model edit this with index: ${widget.index} edit: ${widget.isEdit}");
      ClubUserModel clubUserModel = ClubUserModel(
        id: widget.clubModel!.id,
        password: passwordController.text.trim(),
        userId: userIdController.text.trim(),
        name: clubNameController.text.trim(),
        profileImage: thumbnailImageUrl,
        clubId: loggedInClubModel.id.isEmpty ? "" : loggedInClubModel.id,
        mobileNumber: mobileNumberController.text.trim(),
        createdTime: widget.clubModel!.createdTime,
        adminEnabled: isAdminEnabled,
        adminType: "club_user",
        clubEnabled: isClubEnabled,
        updatedTime: Timestamp.now(),
      );

      // await clubController.AddClubToFirebase(clubModel);
      await clubController.AddClubUserToFirebase(clubUserModel);

      if (context.mounted && context.checkMounted()) {
        MyToast.showSuccess(context: context, msg: 'Product Edited successfully');
      }
    } else {
      MyPrint.printOnConsole("club model new duplicate");
      ClubUserModel clubUserModel = ClubUserModel(
        id: newId,
        name: clubNameController.text.trim(),
        password: passwordController.text.trim(),
        userId: userIdController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        profileImage: thumbnailImageUrl,
        adminEnabled: isAdminEnabled,
        adminType: MyAppConstants.clubUserType,
        clubId: loggedInClubModel.id.isEmpty ? "": loggedInClubModel.id,
        // adminType: adminType
        clubEnabled: isClubEnabled,
        createdTime: Timestamp.now(),
      );

      await clubController.AddClubUserToFirebase(clubUserModel);
      if (context.mounted && context.checkMounted()) {
        MyToast.showSuccess(context: context, msg: 'Club added successfully');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getData() async {}

  @override
  void initState() {
    super.initState();
    clubProvider = Provider.of<ClubProvider>(context, listen: false);
    clubController = ClubController(clubProvider: clubProvider);
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
                          title: "Add Club User",
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
            CommonText(text: " Basic Information", fontWeight: FontWeight.bold, fontSize: 22, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 20,
            ),
            getNameAndMobileNumber(),
            const SizedBox(
              height: 30,
            ),
            getUserIdAndPasswordField(),
            const SizedBox(
              height: 30,
            ),
            // getEnabledRow(),
            // const SizedBox(
            //   height: 30,
            // ),
            CommonText(text: " Images", fontWeight: FontWeight.bold, fontSize: 22, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 10,
            ),
            getAddImageRow(),
            const SizedBox(
              height: 30,
            ),
            getAddClubButton(),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget getTitle({required String title}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: CommonText(
        text: " $title",
        fontWeight: FontWeight.bold,
        fontSize: 16,
        textAlign: TextAlign.start,
        color: Styles.bgSideMenu,
      ),
    );
  }

  Widget getNameAndMobileNumber() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Enter User Name*"),
              CommonTextFormField(
                controller: clubNameController,
                hintText: "Enter Club Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter a Club Name";
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Enter Mobile Number*"),
              CommonTextFormField(
                controller: mobileNumberController,
                hintText: "Enter Mobile Number",
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Mobile Number Cannot be empty";
                  } else {
                    if (RegExp(r"^\d{10}").hasMatch(val)) {
                      return null;
                    } else {
                      return "Invalid Mobile Number";
                    }
                  }
                },
                keyboardType: TextInputType.number,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getUserIdAndPasswordField() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Enter UserId*"),
              CommonTextFormField(
                controller: userIdController,
                hintText: "Enter UserId",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter a userId";
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Enter Password*"),
              CommonTextFormField(
                controller: passwordController,
                hintText: "Enter Password",
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Password cannot be empty";
                  } else {
                    if (val.length < 6) {
                      return "Password must be of six characters";
                    } else {
                      return null;
                    }
                  }
                },
                keyboardType: TextInputType.number,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getEnabledRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getTitle(
                title: 'Admin Enabled :    ',
              ),
              getTestEnableSwitch(
                value: isAdminEnabled,
                onChanged: (val) {
                  setState(() {
                    isAdminEnabled = val ?? true;
                  });
                },
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getTitle(
                title: 'Club Enabled :    ',
              ),
              getTestEnableSwitch(
                value: isClubEnabled,
                onChanged: (val) {
                  setState(() {
                    isClubEnabled = val ?? true;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getTestEnableSwitch({
    required bool value,
    void Function(bool?)? onChanged,
  }) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Styles.bgSideMenu,
    );
  }

  Widget getAddImageRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(title: "Choose Club User Image*"),
        thumbnailImage == null
            ? InkWell(
                onTap: () async {
                  await addThumbnailImage();
                },
                child: const EmptyImageViewBox())
            : CommonImageViewBox(
                imageAsBytes: thumbnailImage,
                rightOnTap: () {
                  thumbnailImage = null;
                  setState(() {});
                },
              ),
      ],
    );
  }

  Widget getAddClubButton() {
    return CommonButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (thumbnailImage == null) {
              MyToast.showError(context: context, msg: 'Please upload a club thumbnail image');
              return;
            }
            await addClub();
          }
        },
        text: "+ Add Club User");
  }
}
