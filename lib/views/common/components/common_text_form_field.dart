import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final bool transparent;
  final IconData? suffixIcon,prefixIcon;
  final Function()? suffixOnTap,prefixOnTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;

  const CommonTextFormField({
    Key? key,
    required this.controller,
    this.hintText,
    this.maxLines=1,
    this.minLines=1,
    this.suffixIcon,
    this.suffixOnTap,
    this.prefixIcon,
    this.prefixOnTap,
    this.transparent = false,
    this.inputFormatter,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return TextFormField(
      obscureText:false,
      enableInteractiveSelection: false,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        fillColor: transparent?Colors.transparent:themeData.inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8)),
        hintText: hintText??" ",
        filled: true,
        suffix: suffixIcon!=null?InkWell(
          onTap: suffixOnTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Icon(suffixIcon,size: 20,color:themeData.primaryColor),
          ),
        ):null,
        prefix: prefixIcon!=null?InkWell(
          onTap: prefixOnTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Icon(prefixIcon,size: 20,color:themeData.primaryColor),
          ),
        ):null,
      ),
      validator: validator,
      inputFormatters: inputFormatter,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}
