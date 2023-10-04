import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../model/category_model.dart';
import '../../modules/home/view_model/home_view_model.dart';
import '../const/app_colors.dart';
import 'c_link_preview_widget.dart';
import 'custom_button.dart';
import 'dialog.dart';

class CategoryTile extends StatelessWidget {
  final Category category;

  const CategoryTile({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController urlController = TextEditingController();
    return Consumer(
      builder: (context, ref, child) {
        final homeViewMethods = ref.read(homeViewModelProvider.notifier);
        //Fetch urlRecords for current category
        final urlRecords = homeViewMethods.getCurrentCategorUrl(category);

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0.h),
          child: ExpansionTile(
            collapsedIconColor: AppColor.mainColor,
            title: Text(
              category.category,
              style: TextStyle(
                color: AppColor.mainColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            children: <Widget>[
              Button(
                ontap: () async {
                  //To add a url
                  await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      urlController.text = '';
                      return dialog(
                        context: context,
                        title: 'Add Url',
                        saveCallback: (value) {
                          //save url metadata
                          homeViewMethods.addUrlOrUpdate(
                              url: value, context: context, category: category);
                        },
                        controller: urlController,
                        ref: ref,
                      );
                    },
                  );
                },
                title: 'Add Url',
              ),

              // Display URLs for this category
              ref.watch(homeViewModelProvider).urlRecords.isEmpty
                  ? SizedBox(
                      height: 40.h,
                      width: 340,
                      child: const Center(
                        child: Text(
                          'No Link Added',
                          style: TextStyle(
                            color: AppColor.mainColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) =>
                          homeViewMethods.reorderItems(oldIndex, newIndex),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: urlRecords.length,
                      itemBuilder: (BuildContext context, int index) {
                        final url = urlRecords[index];
                        return GestureDetector(
                          key: Key(url.id.toString()),
                          onDoubleTap: () async {
                            await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                urlController.text = '';
                                return dialog(
                                  context: context,
                                  controller: urlController,
                                  category: category,
                                  ref: ref,
                                  editURl: url,
                                );
                              },
                            );
                          },
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    //Open delete dialog
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return deleteDialog(
                                          context,
                                          () {
                                            //Delete url
                                            homeViewMethods.deleteUrl(url);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: Icons.delete,
                                  foregroundColor: AppColor.mainColor,
                                  backgroundColor: AppColor.backGroundColor,
                                )
                              ],
                            ),
                            closeOnScroll: false,
                            child: CustomLinkPreviewWidget(
                              url: url,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
