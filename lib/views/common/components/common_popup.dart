/*
* File : Location Permission Dialog
* Version : 1.0.0
* */

import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

class CommonPopup extends StatelessWidget {
  final String text, content, leftText, rightText;
  final IconData? icon;
  final Color rightBackgroundColor;
  final Function()? rightOnTap;
  final Function()? leftOnTap;

  const CommonPopup({super.key,
    required this.text,
    this.icon,
    this.content = "",
    this.leftText = "No",
    this.rightText = "Yes",
    this.leftOnTap,
    this.rightOnTap,
    this.rightBackgroundColor = Styles.bgSideMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        // height: MediaQuery.of(context).size.height * .15,
        width: MediaQuery.of(context).size.width * .3,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                icon != null
                    ? Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: Icon(
                          icon,
                          size: 28,
                          color: Colors.black,
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CommonText(
                    text: text,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Visibility(
              visible: content.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                child: CommonText(
                  text: content,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (leftOnTap == null) {
                            Navigator.pop(context);
                          } else {
                            leftOnTap!();
                          }
                        },
                        child: Container(
                            child: CommonText(
                          text: leftText,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: rightOnTap,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            decoration: BoxDecoration(
                              color: rightBackgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: CommonText(
                              text: rightText,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
