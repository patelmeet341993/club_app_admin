import 'package:club_model/configs/styles.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  Function onTap;
  String text;
  double verticalPadding;
  double horizontalPadding;
  Color backgroundColor;
  double fontSize;
  double borderRadius;
  Widget? icon;
  Widget? suffixIcon;
  bool isSelected = true;


  CommonButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.verticalPadding=10,
    this.fontSize=15,
    this.icon,
    this.suffixIcon,
    this.borderRadius=4,
    this.horizontalPadding=20,
    this.backgroundColor=Styles.bgSideMenu,
    this.isSelected=true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: verticalPadding,horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: isSelected?backgroundColor:Styles.white,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            border: Border.all(color: isSelected?Colors.transparent:Styles.bgSideMenu,width: 1),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null ? Padding(
                padding:  EdgeInsets.only(right: 4.0),
                child: icon!,
              ) : Container(),
              Text(
                text,
                style: TextStyle(
                  color: isSelected?Styles.white:Styles.bgSideMenu.withOpacity(0.6),
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              suffixIcon != null ? Padding(
                padding:  EdgeInsets.only(left: 4.0),
                child: suffixIcon!,
              ) : Container(),
            ],
          )),
    );
  }
}
