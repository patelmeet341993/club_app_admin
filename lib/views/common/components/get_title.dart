import 'package:club_model/configs/styles.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

class GetTitle extends StatelessWidget {
  String title;
  double bottomPadding;
  double fontSize;
  GetTitle({required this.title, this.bottomPadding = 8.0,this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: CommonText(
        text: " $title",
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        textAlign: TextAlign.start,
        color: Styles.bgSideMenu.withOpacity(.8),
      ),
    );
  }
}
