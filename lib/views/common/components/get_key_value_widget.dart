import 'package:flutter/material.dart';

class GetKeyValueWidget extends StatelessWidget {
  final String keyString, value;

  const GetKeyValueWidget({
    Key? key,
    required this.keyString,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$keyString : ",
          style: themeData.textTheme.bodyLarge
              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Flexible(
          child: Text(
            value,
            style: themeData.textTheme.bodyLarge
                ?.merge(TextStyle(color: themeData.primaryColor, fontSize: 13)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
