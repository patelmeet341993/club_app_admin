import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_model/club_model.dart';
import 'package:flutter/material.dart';
import 'common_popup.dart';


class CommonImageViewBox extends StatefulWidget {
  File? file;
  String? url;
  Uint8List? imageAsBytes;
  Function()? rightOnTap;
  CommonImageViewBox({this.url,this.file,this.imageAsBytes,this.rightOnTap});

  @override
  State<CommonImageViewBox> createState() => _CommonImageViewBoxState();
}

class _CommonImageViewBoxState extends State<CommonImageViewBox> {

  File? methodFile;
  String? methodUrl;
  Uint8List? methodImageAsBytes;

  @override
  void initState() {
    super.initState();
    methodFile = widget.file;
    methodUrl = widget.url;
    methodImageAsBytes = widget.imageAsBytes;
  }

  @override
  Widget build(BuildContext context) {
    if(methodImageAsBytes != null){
      return Container(
        height: 80,
        width: 80,
        margin: const EdgeInsets.only(right: 15),
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, right: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(6)),
                child: Image.memory(
                  methodImageAsBytes!,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CommonPopup(
                        text: "Are you sure you want to Delete Image?",
                        rightText: "Delete",
                        rightOnTap: (){
                          if(widget.rightOnTap == null){
                            Navigator.pop(context);
                          }else{
                            Navigator.pop(context);
                            widget.rightOnTap!();
                          }
                        },

                      );
                    },
                  );
                  //showDeleteDialogue(index: index, isDocumentfile: false, file: file);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    Icons.close,
                    color: Styles.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      if (methodFile != null) {
        return Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              height: 80,
              width: 80,
              padding:
              const EdgeInsets.only(top: 10, right: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(6)),
                child: Image.file(
                  methodFile!,
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CommonPopup(
                        text: "Are you sure you want to Delete Image?",
                        rightText: "Delete",
                        rightOnTap: (){
                          if(widget.rightOnTap == null){
                            Navigator.pop(context);
                          }else{
                            Navigator.pop(context);
                            widget.rightOnTap!();
                          }
                        },

                      );
                    },
                  );
                  /*showDialog(context: context,
                      builder: (context){
                          return SportiWeDialog(
                              title: "Remove Image", description: "Are you sure you want to remove Image sdkfjl sdlfjh sadfljkshd fas h?",
                              positiveOnTap: () {
                                Navigator.pop(context);
                              },
                          );
                      }
                  );*/
                  // showDeleteDialogue(index: index, isDocumentfile: false, file: file);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      }
      else {
        MyPrint.printOnConsole('yaha pe with $methodUrl');
        return Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              height: 80,
              width: 80,
              margin:
              const EdgeInsets.only(top: 10, right: 10),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(6)),
                child: CachedNetworkImage(
                  imageUrl: getSecureUrl(methodUrl ?? ""),
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.grey[400],
                          size: 100,
                        ),
                      ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CommonPopup(
                        text: "Are you sure you want to Delete Image?",
                        rightText: "Delete",
                        rightOnTap: (){
                          if(widget.rightOnTap == null){
                            Navigator.pop(context);
                          }else{
                            Navigator.pop(context);
                            widget.rightOnTap!();
                          }
                        },
                      );
                    },
                  );
                  //showDeleteDialogue(url: url, index: index, isDocumentfile: false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    }
  }
}



class EmptyImageViewBox extends StatelessWidget {
  const EmptyImageViewBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Icon(Icons.add,color: Styles.bgSideMenu,size: 25),
    );
  }
}
