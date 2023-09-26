import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../modules/home/view_model/home_view_model.dart';
import '../const/app_colors.dart';
import 'c_textfield.dart';

Widget dialog(
  BuildContext context,
  TextEditingController controller,
  WidgetRef ref,
) {
  final formKey = GlobalKey<FormState>();
  return AlertDialog(
    backgroundColor: AppColor.backGroundColor,
    title: Form(
      key: formKey,
      child: CTextfield(
        hintText: 'Enter  url',
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter URL';
          }
          return null;
        },
      ),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
        side: const BorderSide(width: 2, color: AppColor.mainColor)),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            ref
                .read(homeViewModelProvider.notifier)
                .addUrl(url: controller.text);
            Navigator.pop(context, 'Save');
          }
        },
        child: const Text(
          'Save',
          style: TextStyle(color: Colors.red),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
        child: const Text(
          'Cancel',
        ),
      ),
    ],
  );
}
