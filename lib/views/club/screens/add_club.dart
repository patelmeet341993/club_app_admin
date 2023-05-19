import 'dart:typed_data';

import 'package:club_app_admin/backend/club_backend/club_controller.dart';
import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/configs/styles.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:club_model/view/common/components/loading_widget.dart';
import 'package:club_model/view/common/components/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/header_widget.dart';

class AddClub extends StatefulWidget {
  static const String routeName = "/AddClub";
  ClubModel? clubModel;
  bool isEdit = false;
  int? index;
  AddClub({this.clubModel,this.isEdit = false,this.index});

  @override
  State<AddClub> createState() => _AddClubState();
}

class _AddClubState extends State<AddClub> {

  final _formKey = GlobalKey<FormState>();
  late Future<void> futureGetData;
  bool isLoading = false;

  late ClubProvider clubProvider;
  late ClubController clubController;

  TextEditingController clubNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController clubAddressController = TextEditingController();
  String thumbnailImageUrl = '';
  Uint8List? thumbnailImage;

  List<Uint8List> clubImagesInBytes = [];
  List<String> clubImageListInString = [];

  bool isClubEnabled = true;
  bool isAdminEnabled = true;

  Future<void> addThumbnailImage() async {

    setState(() {});
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
      allowCompression: true,
    );

    if(result?.files.firstElement != null) {
      PlatformFile platformFile = result!.files.firstElement!;
      thumbnailImage = platformFile.bytes;

      if (mounted) setState(() {});
    }

  }

  Future<void> addClub() async {
    setState(() {
      isLoading = true;
    });



    if(widget.clubModel != null && widget.index != null && widget.isEdit == true ){
      MyPrint.printOnConsole("test model edit this with index: ${widget.index} edit: ${widget.isEdit}");
      ClubModel clubModel = ClubModel(
        id: widget.clubModel!.id,
        name:  clubNameController.text.trim(),
        address:  clubAddressController.text.trim(),
        mobileNumber:  mobileNumberController.text.trim(),
        thumbnailImageUrl: thumbnailImageUrl,
        createdTime: widget.clubModel!.createdTime,
        adminEnabled: isAdminEnabled,
        clubEnabled: isClubEnabled,
        images: clubImageListInString,
        updatedTime: Timestamp.now(),
      );

      // await productController.AddProductToFirebase(productModel);
      MyToast.showSuccess(context: context, msg: 'Product Edited successfully');

    }else{
      MyPrint.printOnConsole("club model new duplicate");
      ClubModel clubModel = ClubModel(
        id: MyUtils.getNewId(isFromUUuid: false),
        name:  clubNameController.text.trim(),
        address:  clubAddressController.text.trim(),
        mobileNumber:  mobileNumberController.text.trim(),
        thumbnailImageUrl: thumbnailImageUrl,
        adminEnabled: isAdminEnabled,
        clubEnabled: isClubEnabled,
        images: clubImageListInString,
        createdTime: Timestamp.now(),
      );

      await clubController.AddClubToFirebase(clubModel);
      MyToast.showSuccess(context: context, msg: 'Club added successfully');
    }

    setState(() {
      isLoading = false;
    });

  }

  Future<void> chooseClubImagesMethod() async {

    setState(() {});
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
      allowCompression: true,
    );

    if(result?.files.firstElement != null) {
      PlatformFile platformFile = result!.files.firstElement!;

      if (platformFile.bytes != null) {
        clubImagesInBytes.add(platformFile.bytes!);
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> getData() async {

  }

  @override
  void initState() {
    super.initState();
    clubProvider = Provider.of<ClubProvider>(context, listen: false);
    clubController = ClubController(clubProvider: clubProvider);
    futureGetData  = getData();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: futureGetData,
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
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
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios_rounded,size: 28,color: Styles.bgSideMenu,)),
                        const SizedBox(width: 10,),
                        Expanded(child: HeaderWidget(title: "Add Product",)),
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
        }
    );
  }

  Widget getMainBody(){
    return  Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            CommonText(text: " Product Basic Information",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(height: 20,),
            getNameAndMobileNumber(),
            const SizedBox(height: 30,),
            getDescriptionTextField(),
            const SizedBox(height: 30,),
            getEnabledRow(),
            const SizedBox(height: 30,),
            CommonText(text: " Images", fontWeight: FontWeight.bold, fontSize: 22, color: Styles.bgSideMenu.withOpacity(.6)),
            const SizedBox(height: 10,),
            getAddImageRow(),
            const SizedBox(height: 30,),
            getClubImages(),
            const SizedBox(height: 40,),
             getAddClubButton(),
            const SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  Widget getTitle({required String title}){
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: CommonText(
        text: " $title",fontWeight: FontWeight.bold,fontSize: 16,textAlign: TextAlign.start,
        color: Styles.bgSideMenu,
      ),
    );
  }

  Widget getNameAndMobileNumber(){
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Enter Name*"),
              CommonTextFormField(
                controller: clubNameController,
                hintText: "Enter Name",
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "  Please enter a Test Name";
                  }
                  return null;
                },
              ),

            ],
          ),
        ),
        const SizedBox(width: 20,),
        Expanded(child:Column(
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
        ),),
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
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getTitle(title: 'Admin Enabled :    ',),
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
              getTitle(title: 'Club Enabled :    ',),
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

  Widget getAddImageRow(){
   return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(title: "Choose Club Thumbnail Image*"),
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

  Widget getClubImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(title: "Choose Club Images (up to 10 images)"),
        Row(
          children: [
            clubImagesInBytes.isNotEmpty
                ? Flexible(
              child: Container(
                padding: EdgeInsets.zero,
                height: 80,
                child: ListView.builder(
                    itemCount: clubImagesInBytes.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic image = clubImagesInBytes[index];
                      MyPrint.printOnConsole(
                          "image type : ${image.runtimeType.toString()}");
                      return CommonImageViewBox(
                        imageAsBytes: clubImagesInBytes[index],
                        rightOnTap: (){
                          clubImagesInBytes.removeAt(index);
                          MyPrint.printOnConsole('Game List Length in bytes is " ${clubImagesInBytes.length}');
                          setState(() {});
                        },
                      );
                    }),
              ),
            )
                : const SizedBox.shrink(),
            clubImagesInBytes.length < 10
                ? InkWell(
                onTap: (){
                  chooseClubImagesMethod();
                },
                child: const EmptyImageViewBox())
                : const SizedBox.shrink()
          ],
        )
      ],
    );
  }


  Widget getAddClubButton(){
    return CommonButton(
        onTap: ()async{
          if(_formKey.currentState!.validate()){
            if(thumbnailImage == null){
              MyToast.showError(context: context, msg: 'Please upload a club thumbnail image');
              return;
            }
            await addClub();
          }
        },
        text: "+ Add Club");
  }




}

