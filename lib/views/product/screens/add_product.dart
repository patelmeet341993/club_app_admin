import 'dart:typed_data';

import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

import '../../../backend/products_backend/product_controller.dart';
import '../../../backend/products_backend/product_provider.dart';
import '../../common/components/add_price_widget.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_image_view_box.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/get_title.dart';
import '../../common/components/header_widget.dart';

class AddProduct extends StatefulWidget {
  static const String routeName = "/AddProduct";
  final AddProductScreenNavigationArguments arguments;
  AddProduct({required this.arguments});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  ProductModel? pageProductModel;

  late ProductProvider productProvider;
  late ProductController productController;
  late Future<void> futureGetData;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeInMLController = TextEditingController();
  String thumbnailImageUrl = '';
  Uint8List? thumbnailImage;
  String brandThumbnailImageUrl = '';
  Uint8List? brandThumbnailImage;

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
      brandThumbnailImage = platformFile.bytes;
      if (mounted) setState(() {});
    }
  }

  Future<void> getData() async {
    MyPrint.printOnConsole('is edit is ${widget.arguments.isEdit}');
    if (widget.arguments.productModel != null) {
      pageProductModel = widget.arguments.productModel;
    }

    if (pageProductModel != null) {
      if(pageProductModel!.brand != null){
        print("insisde");
        brandNameController.text = pageProductModel!.brand!.name;
        brandThumbnailImageUrl = pageProductModel!.brand!.thumbnailImageUrl;
      }
      nameController.text = pageProductModel!.name;
      priceController.text = ParsingHelper.parseStringMethod(pageProductModel!.price);
      sizeInMLController.text = ParsingHelper.parseStringMethod(pageProductModel!.sizeInML);
      thumbnailImageUrl = pageProductModel!.thumbnailImageUrl;
    }
  }

  Future<void> submitProduct() async {
    setState(() {
      isLoading = true;
    });

    String productId = pageProductModel?.id ?? "";
    if (productId.isEmpty) {
      productId = MyUtils.getNewId(isFromUUuid: false);
    }

    ProductModel productModel = ProductModel(
      id: MyUtils.getNewId(isFromUUuid: false),
      name: nameController.text.trim(),
      brand: BrandModel(
        name: brandNameController.text.trim(),
        thumbnailImageUrl: brandThumbnailImageUrl,
      ),
      price: double.tryParse(priceController.text) ?? 0,
      sizeInML: double.tryParse(priceController.text) ?? 0,
      thumbnailImageUrl: thumbnailImageUrl,
      createdTime: pageProductModel?.createdTime ?? Timestamp.now(),
      updatedTime: pageProductModel != null ? Timestamp.now() : null,
    );

    await productController.AddProductToFirebase(productModel,
      isAdInProvider: pageProductModel == null
    );

    if(pageProductModel != null) {
      ProductModel model = productModel;
      model.name = productModel.name;
      model.sizeInML = productModel.sizeInML;
      model.brand = productModel.brand;
      model.price = productModel.price;
      model.createdTime = productModel.createdTime;
      model.updatedTime = productModel.updatedTime;
      model.thumbnailImageUrl = productModel.thumbnailImageUrl;
    }

    setState(() {
      isLoading = false;
    });

    MyToast.showSuccess(context: context, msg: pageProductModel == null ? 'Product Added Successfully' : 'Product Edited Successfully');

  }

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productController = ProductController(productProvider: productProvider);
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
                          title: "Add Product",
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
                text: " Product Basic Information",
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
            getPricingRow(),
            const SizedBox(
              height: 30,
            ),
            CommonText(
                text: " Images",
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
    return CommonText(
      text: "  $title",
      fontWeight: FontWeight.bold,
      fontSize: 15,
      textAlign: TextAlign.start,
      color: Styles.bgSideMenu,
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
              getTitle(title: "Enter Name*"),
              CommonTextFormField(
                controller: nameController,
                hintText: "Enter Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter a Test Name";
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
              getTitle(title: "Enter Brand Name*"),
              CommonTextFormField(
                controller: brandNameController,
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
      ],
    );
  }

  Widget getPricingRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Price*"),
              AddPriceWidget(
                controller: priceController,
                onChanged: (value) {
                  priceController.text = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value == "0") {
                    return "  Please enter a Price";
                  }
                  return null;
                },
              )
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
              getTitle(title: "Size(ml)"),
              AddPriceWidget(
                controller: sizeInMLController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "  Please enter a Discounted Price";
                  }
                  return null;
                },
              )
            ],
          ),
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
              GetTitle(title: "Choose Product Thumbnail Image*"),
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
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetTitle(title: "Choose Brand Thumbnail Image*"),
              brandThumbnailImage == null
                  ? InkWell(
                      onTap: () async {
                        await addBrandThumbnailImage();
                      },
                      child: const EmptyImageViewBox())
                  : CommonImageViewBox(
                      imageAsBytes: brandThumbnailImage,
                      rightOnTap: () {
                        brandThumbnailImage = null;
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
            if (thumbnailImage == null && thumbnailImageUrl.checkEmpty) {
              MyToast.showError(
                  context: context,
                  msg: 'Please upload a product thumbnail image');
              return;
            }
            if (brandThumbnailImage == null) {
              MyToast.showError(
                  context: context,
                  msg: 'Please upload a product brand thumbnail image');
              return;
            }
            await submitProduct();
            Navigator.pop(context);
          }
        },
        text: "+ Add Product");
  }
}
