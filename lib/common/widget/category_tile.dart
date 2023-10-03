import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../model/category_model.dart';
import '../../model/url_modell.dart';
import '../../modules/home/view_model/home_view_model.dart';
import '../const/app_colors.dart';
import 'c_link_preview_widget.dart';
import 'custom_button.dart';
import 'dialog.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final List<Url> urlRecords;

  const CategoryTile(
      {super.key, required this.category, required this.urlRecords});

  @override
  Widget build(BuildContext context) {
    final TextEditingController urlController = TextEditingController();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: Consumer(
        builder: (context, ref, child) {
          return ExpansionTile(
            collapsedIconColor: AppColor.mainColor,
            title: Text(
              category.category,
              style: const TextStyle(color: AppColor.mainColor),
            ),
            children: <Widget>[
              Button(
                ontap: () async {
                  await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      urlController.text = '';
                      return dialog(
                          context: context,
                          title: 'Add Url',
                          saveCallback: (value) {
                            ref
                                .read(homeViewModelProvider.notifier)
                                .addUrlOrUpdate(
                                    url: value,
                                    context: context,
                                    category: category);
                          },
                          controller: urlController,
                          ref: ref);
                    },
                  );
                },
                title: 'Add Url',
              ),

              // Display URLs for this category
              ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) => ref
                    .read(homeViewModelProvider.notifier)
                    .reorderItems(oldIndex, newIndex),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: urlRecords.length,
                itemBuilder: (BuildContext context, int index) {
                  final url = urlRecords[index];
                  // print(url.url);
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
                              editURl: url);
                        },
                      );
                    },
                    child: Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return deleteDialog(
                                      context,
                                      () {
                                        ref
                                            .read(
                                                homeViewModelProvider.notifier)
                                            .deleteUrl(url);
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
                        )
                        //     Tile(
                        //   url: url,
                        // ),
                        ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
