import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/app_colors.dart';

class CTextfield extends StatefulWidget {
  final String hintText;

  final String? Function(String?)? validator;
  final TextEditingController controller;
  const CTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  State<CTextfield> createState() => _CTextfieldState();
}

class _CTextfieldState extends State<CTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      style: TextStyle(
          color: AppColor.mainColor,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp),
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            color: AppColor.mainColor,
            fontWeight: FontWeight.normal),
        fillColor: AppColor.backGroundColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainColor, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainColor, width: 2),
        ),
      ),
    );
  }
}
