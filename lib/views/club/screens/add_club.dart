import 'package:club_app_admin/backend/club_backend/club_controller.dart';
import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/backend/club_operator_backend/club_operator_provider.dart';
import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/club/data_model/club_operator_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../backend/club_operator_backend/club_operator_controller.dart';
import '../../../backend/common/cloudinary_manager.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/header_widget.dart';
import '../componants/add_club_operator_dialog.dart';

class AddClub extends StatefulWidget {
  static const String routeName = "/AddClub";
  final AddClubScreenNavigationArguments arguments;

  AddClub({required this.arguments});

  @override
  State<AddClub> createState() => _AddClubState();
}

class _AddClubState extends State<AddClub> {
  final _formKey = GlobalKey<FormState>();
  late Future<void> futureGetData;
  bool isLoading = false;

  late ClubProvider clubProvider;
  late ClubController clubController;
  ClubOperatorProvider clubOperatorProvider = ClubOperatorProvider();
  ClubModel? pageClubModel;
  ClubOperatorModel? pageClubOperatorModel;
  late ClubOperatorController myClubOperatorController;
  late ClubOperatorProvider myClubOperatorProvider;
  TextEditingController clubNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController clubAddressController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? thumbnailImageUrl;
  Uint8List? thumbnailImage;
  List<dynamic> clubCoverImages = [];
  List<String> coverImagesToDeleteList = [];

  bool isClubEnabled = true;
  bool isAdminEnabled = true;
  bool isUserOperator = false;


  Future<void> addThumbnailImage() async {
    setState(() {});
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      thumbnailImage = await file.readAsBytes();
      MyPrint.printOnConsole("Mime type: ${file.mimeType}");
    }
    if (mounted) setState(() {});
  }

  Future<void> getAddUserOperator() async {
   dynamic value = await showDialog(
      context: context,
      builder: (context) {
        return AddClubOperatorDialog(clubOperatorProvider: clubOperatorProvider,);
      },
   );

   if(value != null && value is ClubOperatorModel){
     pageClubOperatorModel = value;
     setState(() {});
   }

  }

  Future<void> addClub() async {
    setState(() {
      isLoading = true;
    });
    String newId = MyUtils.getNewId(isFromUUuid: false);
    String cloudinaryThumbnailImageUrl = '';

    if (thumbnailImage != null) {
      List<String> uploadedImages = [];
      uploadedImages = await CloudinaryManager().uploadImagesToCloudinary([thumbnailImage!]);
      if (uploadedImages.isNotEmpty) {
        cloudinaryThumbnailImageUrl = uploadedImages.first;
      }
    }

    for (var element in clubCoverImages) {
      if(element is Uint8List){
        List<String> imageUrls = await  CloudinaryManager().uploadImagesToCloudinary([element]);
        if (imageUrls.isNotEmpty) {
          clubCoverImages.add(imageUrls.first);
        }
      }
    }
    for (var element in coverImagesToDeleteList) {
        await  CloudinaryManager().deleteImagesFromCloudinary(images: [element]);
    }
    MyPrint.printOnConsole("Club Cover Images Length: ${clubCoverImages.length}");

    List<String> methodCoverImages = [];
    for(var element in clubCoverImages){
      if(element is String){
        methodCoverImages.add(element);
      }
    }


    if (widget.arguments.clubModel != null && widget.arguments.index != null && widget.arguments.isEdit == true) {
      MyPrint.printOnConsole("club model edit this with index: ${widget.arguments.index} edit: ${widget.arguments.isEdit}");
      ClubModel clubModel = ClubModel(
        id: widget.arguments.clubModel!.id,
        name: clubNameController.text.trim(),
        address: clubAddressController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        thumbnailImageUrl: cloudinaryThumbnailImageUrl.isNotEmpty ? cloudinaryThumbnailImageUrl : widget.arguments.clubModel!.thumbnailImageUrl,
        createdTime: widget.arguments.clubModel!.createdTime,
        adminEnabled: isAdminEnabled,
        clubUsersList: pageClubOperatorModel != null ? [pageClubOperatorModel!.id] : null,
        userRoles: pageClubOperatorModel != null ? {pageClubOperatorModel!.id : ClubOperatorRoles.owner} : null,
        coverImages: methodCoverImages,
        updatedTime: Timestamp.now(),
      );
      await clubController.AddClubToFirebase(clubModel,isEdit: true);
      if(pageClubOperatorModel != null){
        pageClubOperatorModel!.clubIds = [clubModel.id];
        pageClubOperatorModel!.clubRoles = {clubModel.id:ClubOperatorRoles.owner};
        await myClubOperatorController.addClubOperatorToFirebase(pageClubOperatorModel!,isEdit: true);
      }
      if (context.mounted && context.checkMounted()) {
        MyToast.showSuccess(context: context, msg: 'Club Updated successfully');
      }
    } else {
      ClubModel clubModel = ClubModel(
        id: newId,
        name: clubNameController.text.trim(),
        address: clubAddressController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        thumbnailImageUrl: cloudinaryThumbnailImageUrl,
        adminEnabled: isAdminEnabled,
        coverImages: methodCoverImages,
        createdTime: Timestamp.now(),
        clubUsersList: pageClubOperatorModel != null ? [pageClubOperatorModel!.id] : null,
        userRoles: pageClubOperatorModel != null ? {pageClubOperatorModel!.id : ClubOperatorRoles.owner} : null,

      );
      await clubController.AddClubToFirebase(clubModel);
      if(pageClubOperatorModel != null){
        pageClubOperatorModel!.clubIds = [clubModel.id];
        pageClubOperatorModel!.clubRoles = {clubModel.id:ClubOperatorRoles.owner};
        await myClubOperatorController.addClubOperatorToFirebase(pageClubOperatorModel!,isEdit: false);
      }
      if (context.mounted && context.checkMounted()) {
        MyToast.showSuccess(context: context, msg: 'Club added successfully');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> chooseClubGalleryImagesMethod(List<dynamic> list) async {
    List<XFile> xFiles = await _picker.pickMultiImage();

    if (xFiles.isNotEmpty) {
      for (var element in xFiles) {
        Uint8List xFile = await element.readAsBytes();
        list.add(xFile);
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> chooseClubCoverImagesMethod() async {
    XFile? xFileAbove = await _picker.pickImage(source: ImageSource.gallery);

    if (xFileAbove != null) {
      Uint8List xFile = await xFileAbove.readAsBytes();
      clubCoverImages.add(xFile);
    }
    if (mounted) setState(() {});
  }

  Future<void> getData() async {
    MyPrint.printOnConsole('Page Club Model : ${widget.arguments.clubModel}');
    if (widget.arguments.clubModel != null) {
      pageClubModel = widget.arguments.clubModel!;
      MyPrint.printOnConsole('Club Model : ${pageClubModel!.toMap()}');
      clubNameController.text = pageClubModel!.name;
      mobileNumberController.text = pageClubModel!.mobileNumber;
      clubAddressController.text = pageClubModel!.address;
      thumbnailImageUrl = pageClubModel!.thumbnailImageUrl;
      isAdminEnabled = pageClubModel!.adminEnabled;
      clubCoverImages.addAll(pageClubModel!.coverImages);
      if(pageClubModel!.clubUsersList.first.isNotEmpty){
      String clubOwnerId = pageClubModel!.clubUsersList.first;
      dynamic value = await clubController.getClubOperatorFromId(clubOwnerId);
      if(value != null && value is ClubOperatorModel){
        pageClubOperatorModel = value;
       }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    clubProvider = Provider.of<ClubProvider>(context, listen: false);
    clubController = ClubController(clubProvider: clubProvider);
    myClubOperatorProvider = Provider.of<ClubOperatorProvider>(context, listen: false);
    myClubOperatorController = ClubOperatorController(clubOperatorProvider: myClubOperatorProvider);
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
                          title: "Add Club",
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
            CommonText(text: " Product Basic Information", fontWeight: FontWeight.bold, fontSize: 25, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 20,
            ),
            getNameAndMobileNumber(),
            const SizedBox(
              height: 30,
            ),
            getDescriptionTextField(),
            const SizedBox(
              height: 30,
            ),
            CommonText(text: " Images", fontWeight: FontWeight.bold, fontSize: 25, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 10,
            ),
            getAddThumbnailImage(),
            const SizedBox(
              height: 30,
            ),
            getClubCoverImages(),
            const SizedBox(
              height: 40,
            ),
            CommonText(text: " Club Owner", fontWeight: FontWeight.bold, fontSize: 22, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(
              height: 20,
            ),
            getClubOperator(),
            const SizedBox(
              height: 40,
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
              getTitle(title: "Enter Club Name*"),
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
        const SizedBox(
          width: 20,
        ),
        getEnabledRow(),
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
                    if (val.length > 6) {
                      return "Password must be of six numbers";
                    } else {
                      return null;
                    }
                  }
                },
                keyboardType: TextInputType.number,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(6),
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

  Widget getDescriptionTextField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(title: "Enter Address Of Club"),
        CommonTextFormField(
          controller: clubAddressController,
          hintText: "Enter Address of Club",
          minLines: 2,
          maxLines: 10,
          validator: (value) {
            return null;
          },
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

  Widget getAddThumbnailImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(title: "Choose Club Thumbnail Image*"),
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
    );
  }

  Widget getClubCoverImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(title: "Upload Club Cover Images(up to 10 images)"),
        Row(
          children: [
            clubCoverImages.isNotEmpty
                ? Flexible(
                    child: Container(
                      padding: EdgeInsets.zero,
                      height: 80,
                      child: ListView.builder(
                          itemCount: clubCoverImages.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            dynamic image = clubCoverImages[index];
                            MyPrint.printOnConsole("image type : ${image.runtimeType.toString()}");
                            return CommonImageViewBox(
                              imageAsBytes: image is Uint8List ? image : null,
                              url: image is String ? image : null,
                              rightOnTap: () {
                                clubCoverImages.removeAt(index);
                                if(image is String){
                                  coverImagesToDeleteList.add(image);
                                }
                                MyPrint.printOnConsole('Club List Length is " ${clubCoverImages.length}');
                                setState(() {});
                              },
                            );
                          }),
                    ),
                  )
                : const SizedBox.shrink(),
            clubCoverImages.length < 10
                ? InkWell(
                    onTap: () async {
                      await chooseClubCoverImagesMethod();
                      MyPrint.printOnConsole('Club Cover Images Length: ${clubCoverImages.length}');
                      MyPrint.printOnConsole('Club Cover Images Type: ${clubCoverImages.first.runtimeType}');
                    },
                    child: const EmptyImageViewBox())
                : const SizedBox.shrink()
          ],
        )
      ],
    );
  }

  Widget getClubOperator(){
    if(pageClubOperatorModel != null){
      return getClubOperatorWidget(pageClubOperatorModel!);
    }
    return InkWell(
      onTap: () async {
        await getAddUserOperator();
      },
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 12).copyWith(top: 15),
          decoration: BoxDecoration(
            color: Styles.bgSideMenu,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Styles.bgSideMenu)
          ),
          child: CommonText(
            text: '+ Add Club Owner',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget getClubOperatorWidget(ClubOperatorModel clubOperatorModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Styles.white,
        border: Border.all(color: Styles.yellow, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Styles.bgSideMenu.withOpacity(.6)),
            ),
            child: CommonCachedNetworkImage(
              imageUrl: clubOperatorModel.profileImageUrl,
              height: 50,
              width: 50,
              borderRadius: 4,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: clubOperatorModel.name,
                  fontSize: 20,
                  maxLines: 1,
                  fontWeight: FontWeight.bold,
                  textOverFlow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: CommonText(
                        text: 'Mobile Number : ${clubOperatorModel.mobileNumber}',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textOverFlow: TextOverflow.ellipsis,
                         maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 50),
                    Flexible(
                      child: CommonText(
                        text: 'Email : ${clubOperatorModel.emailId}',
                        textAlign: TextAlign.center,
                        maxLines:1,
                        fontSize: 16,
                        textOverFlow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          // Spacer(),
          InkWell(
            onTap: (){
              pageClubOperatorModel = null;
              setState(() {});
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.close,color: Styles.bgSideMenu,),
            ),
          ),
        ],
      ),
    );
  }


  Widget getAddClubButton() {
    return CommonButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (thumbnailImage == null && thumbnailImageUrl.checkEmpty) {
              MyToast.showError(context: context, msg: 'Please upload a club thumbnail image');
              return;
            }
            await addClub();
            Navigator.pop(context);
          }
        },
        text: pageClubModel != null ? 'Update Club' : "+ Add Club");
  }
}
