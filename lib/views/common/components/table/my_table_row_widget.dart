import 'package:flutter/material.dart';
import 'my_table_cell_model.dart';

class MyTableRowWidget extends StatelessWidget {
  final List<MyTableCellModel> cells;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsets? margin, padding, contentMargin, contentPadding;

  const MyTableRowWidget({
    Key? key,
    required this.cells,
    this.borderRadius = 6,
    this.backgroundColor,
    this.margin,
    this.padding,
    this.contentMargin = const EdgeInsets.symmetric(horizontal: 5),
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (cells.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: margin,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? themeData.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: cells.map((e) {
          return Expanded(
            flex: e.flex,
            child: Container(
              margin: contentMargin,
              padding: contentPadding,
              child: e.child,
            ),
          );
        }).toList(),
      ),
    );
  }
}
