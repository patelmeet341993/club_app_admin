import 'dart:ui';

import 'package:club_app_admin/backend/club_operator_backend/club_operator_controller.dart';
import 'package:club_app_admin/backend/club_operator_backend/club_operator_provider.dart';
import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/club/data_model/club_operator_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../backend/common/cloudinary_manager.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/header_widget.dart';

class AddClubOperator extends StatefulWidget {
  static const String routeName = "/AddClubOperator";
  final AddClubOperatorNavigationArguments arguments;

  AddClubOperator({required this.arguments});

  @override
  State<AddClubOperator> createState() => _AddClubOperatorState();
}

class _AddClubOperatorState extends State<AddClubOperator> {
  final _formKey = GlobalKey<FormState>();
  late Future<void> futureGetData;
  bool isLoading = false;

  late ClubOperatorProvider clubOperatorProvider;
  late ClubOperatorController clubOperatorController;
  ClubOperatorModel? pageClubOperatorModel;

  TextEditingController operatorNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? profileImageUrl;
  Uint8List? profileImageInBytes;
  bool isAdminEnabled = true;

  Future<void> addThumbnailImage() async {
    setState(() {});
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      profileImageInBytes = await file.readAsBytes();
      MyPrint.printOnConsole("Mime type: ${file.mimeType}");
    }
    if (mounted) setState(() {});
  }

  Future<void> addClubOperator() async {
    setState(() {
      isLoading = true;
    });
    String newId = MyUtils.getNewId(isFromUUuid: false);
    String cloudinaryProfileImageUrl = '';

    if (profileImageInBytes != null) {
      List<String> uploadedImages = [];
      uploadedImages = await CloudinaryManager().uploadImagesToCloudinary([profileImageInBytes!]);
      if (uploadedImages.isNotEmpty) {
        cloudinaryProfileImageUrl = uploadedImages.first;
      }
    }

    if (widget.arguments.clubOperatorModel != null && widget.arguments.index != null && widget.arguments.isEdit == true) {

      MyPrint.printOnConsole("club Operator model edit this with index: ${widget.arguments.index} edit: ${widget.arguments.isEdit}");
      ClubOperatorModel clubOperatorModel = ClubOperatorModel(
        id: widget.arguments.clubOperatorModel!.id,
        name: operatorNameController.text.trim(),
        emailId: emailIdController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        password: passwordController.text.trim(),
        profileImageUrl: cloudinaryProfileImageUrl.isNotEmpty ? cloudinaryProfileImageUrl : widget.arguments.clubOperatorModel!.profileImageUrl,
        createdTime: widget.arguments.clubOperatorModel!.createdTime,
        adminEnabled: isAdminEnabled,
        updatedTime: Timestamp.now(),

      );
      await clubOperatorController.addClubOperatorToFirebase(clubOperatorModel,isEdit: true);
      if (context.mounted && context.checkMounted()) {
        MyToast.showSuccess(context: context, msg: 'Club Operator Updated successfully');
      }

    } else {

      ClubOperatorModel clubOperatorModel = ClubOperatorModel(
        id: newId,
        name: operatorNameController.text.trim(),
        emailId: emailIdController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        profileImageUrl: cloudinaryProfileImageUrl,
        adminEnabled: isAdminEnabled,
        password: passwordController.text.trim(),
        createdTime: Timestamp.now(),
      );
      await clubOperatorController.addClubOperatorToFirebase(clubOperatorModel);
      if (context.mounted && context.checkMounted()) {
        MyToast.showSuccess(context: context, msg: 'Club Operator added successfully');
      }

    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getData() async {
    MyPrint.printOnConsole('Page Club Operator Model : ${widget.arguments.clubOperatorModel}');
    if (widget.arguments.clubOperatorModel != null) {
      pageClubOperatorModel = widget.arguments.clubOperatorModel!;
      MyPrint.printOnConsole('Club Operator Model : ${pageClubOperatorModel!.toMap()}');
      operatorNameController.text = pageClubOperatorModel!.name;
      emailIdController.text = pageClubOperatorModel!.emailId;
      passwordController.text = pageClubOperatorModel!.password;
      mobileNumberController.text = pageClubOperatorModel!.mobileNumber;
      profileImageUrl = pageClubOperatorModel!.profileImageUrl;
      isAdminEnabled = pageClubOperatorModel!.adminEnabled;
    }
  }

  @override
  void initState() {
    super.initState();
    clubOperatorProvider = context.read<ClubOperatorProvider>();
    clubOperatorController = ClubOperatorController(clubOperatorProvider: clubOperatorProvider);
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
                              title: "Add Club Operator",
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
            CommonText(text: " Club Operator Basic Information", fontWeight: FontWeight.bold, fontSize: 25, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 20,
            ),
            getNameAndMobileNumber(),
            const SizedBox(
              height: 30,
            ),
            getEmailIdAndPasswordField(),
            const SizedBox(
              height: 30,
            ),
            CommonText(text: " Images", fontWeight: FontWeight.bold, fontSize: 25, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 10,
            ),
            getAddProfileImage(),
            const SizedBox(
              height: 40,
            ),
            getAddClubOperatorButton(),
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
              getTitle(title: "Enter Club Operator Name*"),
              CommonTextFormField(
                controller: operatorNameController,
                hintText: "Enter Club Operator Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter a Club Operator Name";
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
        const SizedBox(
          width: 20,
        ),
        getEnabledRow(),
      ],
    );
  }

  Widget getEmailIdAndPasswordField() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Enter Email Id*"),
              CommonTextFormField(
                controller: emailIdController,
                hintText: "Enter email Id",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter a email Id";
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
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getEnabledRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getTitle(
          title: 'Admin Enabled',
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

  Widget getAddProfileImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(title: "Choose Club Operator Profile Image*"),
        profileImageInBytes == null && profileImageUrl == null && (profileImageUrl?.isEmpty ?? true)
            ? InkWell(
            onTap: () async {
              await addThumbnailImage();
            },
            child: const EmptyImageViewBox())
            : CommonImageViewBox(
          imageAsBytes: profileImageInBytes,
          url: profileImageUrl,
          rightOnTap: () {
            profileImageInBytes = null;
            profileImageUrl = null;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget getClubGalleryImages(){
    return Column(
      children: [
        getTitle(title: "Choose Gallery Images for different Categories"),

      ],
    );
  }

  Widget getAddClubOperatorButton() {
    return CommonButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (profileImageInBytes == null && profileImageUrl.checkEmpty) {
              MyToast.showError(context: context, msg: 'Please upload a Club Operator Profile Image');
              return;
            }
            await addClubOperator();
            Navigator.pop(context);
          }
        },
        text: pageClubOperatorModel != null ? 'Update Club Operator' : "+ Add Club Operator");
  }
}
