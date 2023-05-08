import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  static const String routeName = "/AddProduct";

  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CommonText(
          text: 'Add Product',
          color: Colors.black,
          fontSize: 25,
        ),
      ),
    );
  }

  /*Widget getNameAndEnabledRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetTitle(title: "Enter Game Name*"),
              CommonTextFormField(
                controller: gameNameController,
                hintText: "Enter Game Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter Game Name";
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
        Expanded(child: Container()),
      ],
    );
  }

  Widget getDescriptionTextField() {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Enter Description Of Game"),
        CommonTextFormField(
          controller: descriptionController,
          hintText: "Enter Description of Game",
          minLines: 3,
          maxLines: 10,
          validator: (value){
            return null;
          },
        ),
      ],
    );

  }

  Widget getAdminEnabled() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GetTitle(title: 'Admin Enabled :    ', bottomPadding: 0),
        getTestEnableSwitch(
            value: isAdminEnabled,
            onChanged: (val) {
              setState(() {
                isAdminEnabled = val ?? true;
              });
            })
      ],
    );
  }

  Widget chooseThumbnailImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Choose Game Thumbnail Image*"),
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

  Widget getTestEnableSwitch(
      {required bool value, void Function(bool?)? onChanged}) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColor.bgSideMenu,
    );
  }

  Widget getGameImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Choose Game Images"),
        Row(
          children: [
            gameImagesInBytes.isNotEmpty
                ? Flexible(
              child: Container(
                padding: EdgeInsets.zero,
                height: 80,
                child: ListView.builder(
                    itemCount: gameImagesInBytes.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic image = gameImagesInBytes[index];
                      MyPrint.printOnConsole(
                          "image type : ${image.runtimeType.toString()}");
                      return CommonImageViewBox(
                        imageAsBytes: gameImagesInBytes[index],
                        rightOnTap: (){
                          gameImagesInBytes.removeAt(index);
                          MyPrint.printOnConsole('Game List Length in bytes is " ${gameImagesInBytes.length}');
                          setState(() {});
                        },
                      );
                    }),
              ),
            )
                : const SizedBox.shrink(),
            gameImagesInBytes.length < 10
                ? InkWell(
                onTap: (){
                  chooseGameImagesMethod();
                },
                child: const EmptyImageViewBox())
                : const SizedBox.shrink()
          ],
        )
      ],
    );
  }

  Widget submitButton() {
    return CommonButton(
      onTap: () async {
        if (_formkey.currentState!.validate()) {
          if(gameImagesInBytes.length > 10){
            MyToast.showError(context: context, msg: 'You can Upload up to 10 images');
            return;
          }
          if(thumbnailImage == null){
            MyToast.showError(context: context, msg: 'Please upload a game thumbnail image');
            return;
          }
          await addGameToFirebase();
          Navigator.pop(context);
        }
      },
      verticalPadding: 15,
      text: '+   Add Game',
      fontSize: 17,
    );
  }*/
}


/*class _AddProductState extends State<AddProduct> {
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  late GameProvider gameProvider;
  late GameController gameController;
  late Future<void> futureGetData;
  TextEditingController gameNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isAdminEnabled = true;
  String thumbnailImageUrl = '';
  Uint8List? thumbnailImage;
  List<Uint8List> gameImagesInBytes = [];
  List<String> gameImageListInString = [];

  Future<void> getData() async {}

  Future<void> addThumbnailImage() async {
    setState(() {});

    // thumbnailImage = await ImagePickerWeb.getImageAsBytes();

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

  Future<void> chooseGameImagesMethod() async {
    setState(() {});

    // Uint8List? methodImage = await ImagePickerWeb.getImageAsBytes();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
      allowCompression: true,
    );

    if(result?.files.firstElement != null) {
      PlatformFile platformFile = result!.files.firstElement!;

      if (platformFile.bytes != null) {
        gameImagesInBytes.add(platformFile.bytes!);
        if (mounted) setState(() {});
      }
    }
  }

  Future<String> uploadThumbnailImageToCloudinary() async {
    List<Uint8List> thumbTempUploadList = [];
    if(thumbnailImage != null){
      thumbTempUploadList.add(thumbnailImage!);
    }
    List<String> thumbImageUrl = await CloudinaryManager().uploadImagesToCloudinary(thumbTempUploadList);
    return thumbImageUrl.first;
  }

  Future<List<String>> uploadGamesImagesToCloudinary() async {

    List<String> methodImageUrlList = await CloudinaryManager().uploadImagesToCloudinary(gameImagesInBytes);

    return methodImageUrlList;

  }



  Future<void> addGameToFirebase() async {

    setState((){
      isLoading = true;
    });
    String gameId = MyUtils.getUniqueIdFromUuid();
    String thumbImage = await uploadThumbnailImageToCloudinary();
    List<String> gamesImagesUrl = await uploadGamesImagesToCloudinary();

    GameModel gameModel = GameModel(
      id: gameId.trim(),
      name: gameNameController.text.trim(),
      description: descriptionController.text.trim(),
      createdTime: Timestamp.now(),
      thumbnailImage: thumbImage,
      enabled: isAdminEnabled,
      gameImages: gamesImagesUrl,
    );

    await gameController.AddGameToFirebase(gameModel);
    MyPrint.printOnConsole('Added Game Model is ${gameModel.toMap()}');

    setState((){
      isLoading = false;
    });
    MyToast.showSuccess(context: context, msg: 'Game Added Successfully');
  }

  @override
  void initState() {
    super.initState();
    gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameController = GameController(gameProvider: gameProvider);
    futureGetData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureGetData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: AppColor.bgColor,
              body: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      HeaderWidget(title: "Add Games", isBackArrow: true),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getNameAndEnabledRow(),
                              const SizedBox(
                                height: 20,
                              ),
                              getDescriptionTextField(),
                              const SizedBox(
                                height: 20,
                              ),
                              getAdminEnabled(),
                              const SizedBox(
                                height: 20,
                              ),
                              chooseThumbnailImage(),
                              const SizedBox(
                                height: 20,
                              ),
                              getGameImages(),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              submitButton()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const CommonProgressIndicator();
          }
        });
  }

  Widget getNameAndEnabledRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetTitle(title: "Enter Game Name*"),
              CommonTextFormField(
                controller: gameNameController,
                hintText: "Enter Game Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter Game Name";
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
        Expanded(child: Container()),
      ],
    );
  }

  Widget getDescriptionTextField() {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Enter Description Of Game"),
        CommonTextFormField(
          controller: descriptionController,
          hintText: "Enter Description of Game",
          minLines: 3,
          maxLines: 10,
          validator: (value){
            return null;
          },
        ),
      ],
    );

  }

  Widget getAdminEnabled() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GetTitle(title: 'Admin Enabled :    ', bottomPadding: 0),
        getTestEnableSwitch(
            value: isAdminEnabled,
            onChanged: (val) {
              setState(() {
                isAdminEnabled = val ?? true;
              });
            })
      ],
    );
  }

  Widget chooseThumbnailImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Choose Game Thumbnail Image*"),
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

  Widget getTestEnableSwitch(
      {required bool value, void Function(bool?)? onChanged}) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColor.bgSideMenu,
    );
  }

  Widget getGameImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetTitle(title: "Choose Game Images"),
        Row(
          children: [
            gameImagesInBytes.isNotEmpty
                ? Flexible(
              child: Container(
                padding: EdgeInsets.zero,
                height: 80,
                child: ListView.builder(
                    itemCount: gameImagesInBytes.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic image = gameImagesInBytes[index];
                      MyPrint.printOnConsole(
                          "image type : ${image.runtimeType.toString()}");
                      return CommonImageViewBox(
                        imageAsBytes: gameImagesInBytes[index],
                        rightOnTap: (){
                          gameImagesInBytes.removeAt(index);
                          MyPrint.printOnConsole('Game List Length in bytes is " ${gameImagesInBytes.length}');
                          setState(() {});
                        },
                      );
                    }),
              ),
            )
                : const SizedBox.shrink(),
            gameImagesInBytes.length < 10
                ? InkWell(
                onTap: (){
                  chooseGameImagesMethod();
                },
                child: const EmptyImageViewBox())
                : const SizedBox.shrink()
          ],
        )
      ],
    );
  }

  Widget submitButton() {
    return CommonButton(
      onTap: () async {
        if (_formkey.currentState!.validate()) {
          if(gameImagesInBytes.length > 10){
            MyToast.showError(context: context, msg: 'You can Upload up to 10 images');
            return;
          }
          if(thumbnailImage == null){
            MyToast.showError(context: context, msg: 'Please upload a game thumbnail image');
            return;
          }
          await addGameToFirebase();
          Navigator.pop(context);
        }
      },
      verticalPadding: 15,
      text: '+   Add Game',
      fontSize: 17,
    );
  }
}*/
