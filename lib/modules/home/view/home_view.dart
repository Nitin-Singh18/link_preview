import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/const/app_colors.dart';
import '../../../common/widget/category_tile.dart';
import '../../../common/widget/custom_button.dart';
import '../../../common/widget/dialog.dart';
import '../view_model/home_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController categoryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    //To fetch all the categories and urlRecords
    ref.read(homeViewModelProvider.notifier).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = ref.watch(homeViewModelProvider).categoryList;
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: categoryList.isEmpty
          ? const SafeArea(
              child: Center(
                child: Text(
                  'No Category Added',
                  style: TextStyle(color: AppColor.mainColor),
                ),
              ),
            )
          :
          //Display all the categories
          SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        final category = categoryList[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0.w,
                            vertical: 5.h,
                          ),
                          child: CategoryTile(
                            category: category,
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
            //To add a cateogry
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                categoryController.text = '';
                return dialog(
                  context: context,
                  title: 'Add Category',
                  saveCallback: (value) {
                    //save category
                    ref.read(homeViewModelProvider.notifier).addCategory(value);
                  },
                  controller: categoryController,
                  ref: ref,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
