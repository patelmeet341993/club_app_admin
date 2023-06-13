import 'package:club_model/club_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPriceWidget extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  String? Function(String?)? validator = (String? s) {};
  void Function(String)? onChanged = (String s) {};
  AddPriceWidget({required this.controller, this.validator, this.onChanged});

  @override
  _AddPriceWidgetState createState() => _AddPriceWidgetState();
}

class _AddPriceWidgetState extends State<AddPriceWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          // color: AppColor.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                cursorColor: Colors.black,
                textAlign: TextAlign.center,
                validator: widget.validator,
                onChanged: widget.onChanged,
                style: TextStyle(fontSize: 15, color: Colors.black),
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    double currentValue =
                        ParsingHelper.parseDoubleMethod(controller.text);
                    setState(() {
                      currentValue = currentValue + 100.0;
                      controller.text = (currentValue).toString();
                    });
                  },
                  child: Container(
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: Styles.bgSideMenu,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    double currentValue =
                        ParsingHelper.parseDoubleMethod(controller.text);
                    setState(() {
                      if (currentValue >= 100) {
                        currentValue = currentValue - 100.0;
                        controller.text = (currentValue).toString();
                      }
                    });
                  },
                  child: Container(
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Styles.bgSideMenu,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
