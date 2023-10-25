import 'dart:async';
import 'dart:typed_data';

import 'package:club_app_admin/backend/navigation/navigation_arguments.dart';
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../backend/brands_backend/brand_provider.dart';
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
  final AddEditProductNavigationArgument arguments;

  const AddProduct({super.key, required this.arguments});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  ProductModel? pageProductModel;

  late ProductProvider productProvider;
  late ProductController productController;
  late BrandProvider brandProvider;
  late Future<void> futureGetData;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeInMLController = TextEditingController();
  String thumbnailImageUrl = '';
  XFile? thumbnailImage;
  Uint8List? thumbnailUint8List;
  List<String> brandNameList = [];
  List<BrandModel> brandModelList = [];
  BrandModel? selectedBrandModel;

  List<String> productTypes = [];
  String? productTypeValue;

  final ImagePicker _picker = ImagePicker();

  Future<void> addThumbnailImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      thumbnailImage = file;
      thumbnailUint8List = await file.readAsBytes();
      MyPrint.printOnConsole("Mime type: ${file.mimeType}");
    }
    if (mounted) setState(() {});
    // }
  }

  Future<void> getData() async {
    productTypes = ProductType.values;
    MyPrint.printOnConsole('is edit is ${widget.arguments.isEdit}');
    brandModelList.addAll(brandProvider.brandsList);
    for (BrandModel element in brandModelList) {
      brandNameList.add(element.name);
    }

    if (widget.arguments.productModel != null) {
      pageProductModel = widget.arguments.productModel;
      if (pageProductModel!.brand != null) {
         selectedBrandModel = pageProductModel!.brand;
      }
      nameController.text = pageProductModel!.name;
      priceController.text = ParsingHelper.parseStringMethod(pageProductModel!.price);
      sizeInMLController.text = ParsingHelper.parseStringMethod(pageProductModel!.sizeInML);
      thumbnailImageUrl = pageProductModel!.thumbnailImageUrl;
      productTypeValue = pageProductModel!.productType;
    }else{
      priceController.text = ParsingHelper.parseStringMethod(0);
      sizeInMLController.text = ParsingHelper.parseStringMethod(0);
    }
  }

  Future<void> submitProduct() async {
    setState(() {
      isLoading = true;
    });

    if (thumbnailImage != null) {
      thumbnailImageUrl = await productController.uploadImageToFirebase(thumbnailImage!);
    }

    if (widget.arguments.isEdit == true) {
      MyPrint.printOnConsole("test model edit this with index: ${widget.arguments.index} edit: ${widget.arguments.isEdit}");
      ProductModel productModel = ProductModel(
        id: widget.arguments.productModel!.id,
        name: nameController.text.trim(),
        brand: selectedBrandModel,
        price: double.tryParse(priceController.text) ?? 0,
        sizeInML: double.tryParse(sizeInMLController.text) ?? 0,
        thumbnailImageUrl: thumbnailImageUrl,
        productType: productTypeValue ?? '',
        createdBy: ProductCreatorType.admin,
        createdTime: widget.arguments.productModel!.createdTime,
        updatedTime: Timestamp.now(),
      );

      await productController.updateProductToFirebase(productModel);
      if (context.mounted) {
        MyToast.showSuccess(context: context, msg: 'Product Edited successfully');
      }
    } else {
      ProductModel productModel = ProductModel(
        id: MyUtils.getNewId(isFromUUuid: false),
        name: nameController.text.trim(),
        brand: selectedBrandModel,
        price: double.tryParse(priceController.text) ?? 0,
        sizeInML: double.tryParse(sizeInMLController.text) ?? 0,
        thumbnailImageUrl: thumbnailImageUrl,
        productType: productTypeValue ?? '',
        createdBy: ProductCreatorType.admin,
        createdTime: Timestamp.now(),
        updatedTime: Timestamp.now(),
      );
      MyPrint.printOnConsole("productModel : ${productModel.toMap()}");

      await productController.addProductToFirebase(productModel, false);
      if (context.mounted) {
        MyToast.showSuccess(context: context, msg: 'Product added successfully');
      }
    }
    setState(() {
      isLoading = false;
    });

    if(context.mounted && context.checkMounted()){
      MyToast.showSuccess(context: context, msg: pageProductModel == null ? 'Product Added Successfully' : 'Product Edited Successfully');
    }
  }

  Future<void> setData() async {
    ProductModel productModel = widget.arguments.productModel ?? ProductModel();
    selectedBrandModel = productModel.brand;
    nameController.text = productModel.name;
    priceController.text = "${productModel.price}";
    sizeInMLController.text = "${productModel.sizeInML}";
    thumbnailImageUrl = productModel.thumbnailImageUrl;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    brandProvider = context.read<BrandProvider>();
    productController = ProductController(productProvider: productProvider);
    futureGetData = getData();

    if (widget.arguments.isEdit) {
      setData();
    }
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
                              title: widget.arguments.isEdit ? "Edit Product" : "Add Product",
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
            CommonText(text: " Product Basic Information", fontWeight: FontWeight.bold, fontSize: 22, color: Styles.bgSideMenu.withOpacity(.6)),
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
            CommonText(text: " Images", fontWeight: FontWeight.bold, fontSize: 22, color: Styles.bgSideMenu.withOpacity(.6)),
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
              getTitle(title: "Add Brand*"),
              getAutoCompleteTextField(
                title: 'Add Brand',
                validator: (value) {
                  if (selectedBrandModel == null) {
                    return "  Please Add minimum 1 Brand";
                  }
                  return null;
                },
                optionBuilder: (TextEditingValue textEditingValue) {
                  return brandNameList.where((gameName) {
                    return gameName.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (value) {
                  MyPrint.printOnConsole("Selected Value: $value");
                  BrandModel tempBrandModel = brandModelList.where((e) => e.name.trim() == value).first;
                  bool isNotRepeated = false;
                  isNotRepeated = selectedBrandModel?.id != tempBrandModel.id;
                  if (isNotRepeated) {
                    if (tempBrandModel.name.isNotEmpty) {
                      selectedBrandModel = tempBrandModel;
                    }
                  }
                  // selectedApplicationModelList.add(tempApplicationModelList.first);
                  MyPrint.printOnConsole("Name of selected Brand ModelList : $selectedBrandModel");
                  setState(() {});
                },
              ),
              // selectedBrandModel != null
              //     ? Container(
              //         margin: const EdgeInsets.all(4),
              //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Styles.bgSideMenu)),
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             CommonText(
              //               text: selectedBrandModel!.name,
              //               color: Styles.bgSideMenu,
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             const SizedBox(
              //               width: 2,
              //             ),
              //             InkWell(
              //                 onTap: () {
              //                   selectedBrandModel = null;
              //                   setState(() {});
              //                 },
              //                 child: const Icon(
              //                   Icons.close,
              //                   size: 13,
              //                   color: Styles.bgSideMenu,
              //                 ))
              //           ],
              //         ),
              //       )
              //     : SizedBox.shrink()
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
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title: "Choose Product Type"),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 1, color: Styles.bgSideMenu),
                ),
                child: DropdownButton<String>(
                  value: productTypeValue,
                  style: const TextStyle(
                    color: Styles.bgSideMenu,
                    fontSize: 18,
                  ),
                  dropdownColor: Colors.white,
                  underline: Container(),
                  iconEnabledColor: Colors.black,
                  isExpanded: true,
                  hint: CommonText(
                    text: 'Select your Product Type',
                  ),
                  borderRadius: BorderRadius.circular(4),
                  items: productTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (val) async {
                    //await changeStatus(currentProductName: val);
                    if (val is String) {
                      productTypeValue = val;
                      setState(() {});
                    }
                  },
                ),
              ),
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
              getThumbImageViewForEdit(),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Widget getThumbImageViewForEdit() {
    return thumbnailImageUrl.isEmpty && thumbnailUint8List == null
        ? InkWell(
      onTap: () async {
        await addThumbnailImage();
      },
      child: const EmptyImageViewBox(),
    )
        : thumbnailUint8List != null
        ? CommonImageViewBox(
      imageAsBytes: thumbnailUint8List,
      rightOnTap: () {
        thumbnailUint8List = null;
        setState(() {});
      },
    )
        : CommonImageViewBox(
      url: thumbnailImageUrl,
      rightOnTap: () {
        thumbnailImageUrl = "";
        setState(() {});
      },
    );
  }


  Widget getAddProductButton() {
    return CommonButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (thumbnailImage == null && thumbnailImageUrl.isEmpty) {
              MyToast.showError(context: context, msg: 'Please upload a product thumbnail image');
              return;
            }
            await submitProduct();
            if (context.mounted && context.checkMounted()) {
              Navigator.pop(context);
            }
          }
        },
        text: widget.arguments.isEdit ? "Update product" : "+ Add Product");
  }

  Widget getAutoCompleteTextField(
      {required FutureOr<Iterable<String>> Function(TextEditingValue) optionBuilder,
      required Function(String)? onSelected,
      required String title,
      String? Function(String?)? validator}) {
    return Autocomplete<String>(
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Styles.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3, maxHeight: 150),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String option = options.elementAt(index);
                      return InkWell(
                          onTap: () {
                            onSelected(option.toString());
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: Card(
                              color: Colors.white,
                              elevation: 5,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Styles.bgSideMenu.withOpacity(.5), width: 1),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: CommonText(text: option.toString())),
                            ),
                          ));
                    },
                    itemCount: options.length),
              ),
            ),
          );
        },
        optionsBuilder: optionBuilder,
        //     (TextEditingValue textEditingValue){
        //   // if(textEditingValue.text == ""){
        //   //   return Iterable<String>.empty();
        //   // //  return categories;
        //   // }
        //   return dataList.where((String facility) {
        //     return facility.toLowerCase().contains(textEditingValue.text.toLowerCase());
        //   });
        // },
        onSelected: onSelected,

        //     (value) {
        //   MyPrint.printOnConsole("Selected Value: " + value);
        //   selectedList.add(value);
        //   setState(() {});
        // },

        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
          if(selectedBrandModel != null){textEditingController.text = selectedBrandModel!.name;}
          return CommonTextFormField(
            hintText: "Select $title",
            controller: textEditingController,
            focusNode: focusNode,
            validator: validator,
          );
        });
  }
}
