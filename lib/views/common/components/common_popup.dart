/*
* File : Location Permission Dialog
* Version : 1.0.0
* */

import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

class CommonPopup extends StatelessWidget {
  String text;
  String leftText ,rightText;
  IconData? icon;
  Color rightBackgroundColor;
  Function()? rightOnTap;
  Function()? leftOnTap;


  CommonPopup({required this.text,this.icon,this.leftText = "No",this.rightText = "Yes",this.leftOnTap,
    this.rightOnTap,
    this.rightBackgroundColor = Styles.bgSideMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        height: MediaQuery.of(context).size.height*.15,
        width: MediaQuery.of(context).size.width*.3,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                icon!=null?Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Icon(
                    icon,
                    size: 28,
                    color:Colors.black,
                  ),
                ):SizedBox.shrink(),
                SizedBox(width: 8,),
                Expanded(
                  child: CommonText(
                    text: text,
                    fontWeight: FontWeight.w500,

                  ),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: InkWell(
                        onTap:() {
                          if(leftOnTap == null){
                            Navigator.pop(context);
                          }else{
                            leftOnTap!();
                          }
                        },
                        child: Container(
                            child: CommonText(
                              text:leftText ,
                              fontWeight: FontWeight.w500,
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Flexible(
                      child: InkWell(
                        onTap: rightOnTap,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                            decoration: BoxDecoration(
                              color: rightBackgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child:CommonText(
                              text:rightText ,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )
                        ),
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

