import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_preview_app/model/category_model.dart';
import '../../model/url_model.dart';
import '../../modules/home/view_model/home_view_model.dart';
import '../const/app_colors.dart';
import 'c_textfield.dart';

Widget dialog(
    {required BuildContext context,
    void Function(String)? saveCallback,
    Category? category,
    required TextEditingController controller,
    required WidgetRef ref,
    Url? editURl}) {
  if (editURl != null) {
    controller.text = editURl.url;
  }
  final formKey = GlobalKey<FormState>();
  return AlertDialog(
    backgroundColor: AppColor.backGroundColor,
    title: Center(
      child: Text(
        editURl != null ? 'Edit Link' : 'Add URL',
        style: const TextStyle(color: AppColor.mainColor),
      ),
    ),
    content: Form(
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
          Navigator.pop(context, 'Cancel');
        },
        child: const Text(
          'Cancel',
        ),
      ),
      TextButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // final homeVMMethods = ref.read(homeViewModelProvider.notifier);
            if (editURl != null) {
              ref.read(homeViewModelProvider.notifier).addUrlOrUpdate(
                  url: controller.text,
                  context: context,
                  category: category!,
                  editUrl: editURl);
            } else {
              // homeVMMethods.addUrlOrUpdate(
              //     url: controller.text, context: context);
              // homeVMMethods.addCategory(controller.text);
              saveCallback!(controller.text);
            }
          }
          Navigator.pop(context, 'Save');
        },
        child: Text(
          editURl != null ? 'Update' : 'Save',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    ],
  );
}

Widget deleteDialog(BuildContext context, VoidCallback onDelete) {
  return AlertDialog(
    content: const Text('Are you sure you want to delete this URL?'),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Close the dialog
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          onDelete();

          Navigator.of(context).pop(); // Close the dialog
        },
        child: const Text(
          'Delete',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ],
  );
}
