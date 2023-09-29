import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_preview_app/common/widget/category_tile.dart';

import '../../../common/const/app_colors.dart';
import '../../../common/widget/custom_button.dart';
import '../../../common/widget/dialog.dart';
import '../view_model/home_view_model.dart';

class NewHomeView extends ConsumerStatefulWidget {
  const NewHomeView({super.key});

  @override
  ConsumerState<NewHomeView> createState() => _NewHomeViewState();
}

class _NewHomeViewState extends ConsumerState<NewHomeView> {
  final TextEditingController categoryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ref.read(homeViewModelProvider.notifier).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final watchingState = ref.watch(homeViewModelProvider);
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: watchingState.categoryList.isEmpty
          ? const SafeArea(
              child: Center(
                child: Text(
                  'No Link Added',
                  style: TextStyle(color: AppColor.mainColor),
                ),
              ),
            )
          : SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: watchingState.categoryList.length,
                      itemBuilder: (context, index) {
                        final category = watchingState.categoryList[index];

                        final urlRecords = ref
                            .read(homeViewModelProvider.notifier)
                            .getCurrentCategorUrl(category);

                        return Padding(
                          key: Key(category.id.toString()),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0.w, vertical: 5.h),
                          child: CategoryTile(
                            category: category,
                            urlRecords: urlRecords,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        color: AppColor.backGroundColor,
        height: 70.h,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Button(
          isIcon: true,
          ontap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                categoryController.text = '';
                return dialog(
                    context: context,
                    saveCallback: (value) {
                      ref
                          .read(homeViewModelProvider.notifier)
                          .addCategory(value);
                    },
                    controller: categoryController,
                    ref: ref);
              },
            );
          },
        ),
      ),
    );
  }
}
