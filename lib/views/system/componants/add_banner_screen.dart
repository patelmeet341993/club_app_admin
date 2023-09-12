


import 'dart:typed_data';

import 'package:club_model/backend/admin/admin_controller.dart';
import 'package:club_model/backend/admin/admin_provider.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/models/common/data_model/banner_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
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
  bool isExternal = true;
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController onTapUrlController = TextEditingController();
  TextEditingController viewNumberController = TextEditingController();
  String? thumbnailImageUrl;
  Uint8List? thumbnailImage;

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
    pageBannerModel = BannerModel(
      id: MyUtils.getNewId(isFromUUuid: false),
      createdTime: Timestamp.now(),
      isInternal: !isExternal,
      viewNumber: ParsingHelper.parseIntMethod(viewNumberController.text),
      onTapUrl: isExternal?onTapUrlController.text.trim():'',
    );

    await adminController.addBannerToFirebase(bannerModel: pageBannerModel!);
    setState(() {
      isLoading = false;
    });

  }


  Future<void> getData() async {

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
        isExternal ?  Expanded(child:  CommonTextFormField(
          controller: onTapUrlController,
          hintText: "Enter External Banner Click Url",
          validator: null,
          // validator: (value) {
          //   // if (value == null || value.isEmpty) {
          //   //   return "  Please Enter External Banner Click Url";
          //   // }
          //   return null;
          // },
        ),) : SizedBox.shrink()
      ],
    );
  }


  Widget getAddBannerButton() {
    return CommonButton(
        onTap: () async {
          MyPrint.printOnConsole('Helo 0 ');
          if(_formKey.currentState!.validate()) {
            MyPrint.printOnConsole('Helo 1 ');
            if (thumbnailImage == null && thumbnailImageUrl.checkEmpty) {
              MyToast.showError(context: context, msg: 'Please upload a banner image');
              return;
            }
            MyPrint.printOnConsole('Helo 1.5 ');

            if(isExternal){
              if(onTapUrlController.text.isEmpty){
                MyToast.showError(context: context, msg: 'Please Enter an external click URL');
                return;
              }
            }
            MyPrint.printOnConsole('Helo 2 ');

            await addBanner();
            if (context.mounted && context.checkMounted()) {
              Navigator.pop(context);
            }
          }
        },
        text: "+ Add Banner");
  }

  Widget getTestEnableSwitch({required bool value, void Function(bool?)? onChanged}){
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Styles.bgSideMenu,
    );
  }

}
