import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/app_colors.dart';

class Button extends StatelessWidget {
  final VoidCallback ontap;
  final bool isIcon;
  final String? title;
  const Button(
      {super.key, required this.ontap, this.isIcon = false, this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: ontap,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.backGroundColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
              side: const BorderSide(color: AppColor.mainColor))),
        ),
        child: isIcon
            ? Icon(
                Icons.add,
                size: 40.sp,
                color: AppColor.mainColor,
              )
            : Text(
                title ?? "",
                style: TextStyle(fontSize: 14.sp, color: AppColor.mainColor),
              ),
      ),
    );
  }
}
