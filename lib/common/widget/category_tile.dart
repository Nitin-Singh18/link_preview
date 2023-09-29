import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_preview_app/common/const/app_colors.dart';
import 'package:url_preview_app/common/widget/custom_button.dart';
import 'package:url_preview_app/common/widget/tile.dart';
import 'package:url_preview_app/model/category_model.dart';

import '../../model/url_model.dart';
import '../../modules/home/view_model/home_view_model.dart';
import 'dialog.dart';

class CategoryTile extends ConsumerStatefulWidget {
  final Category category;
  final List<Url> urlRecords;
  const CategoryTile(
      {super.key, required this.category, required this.urlRecords});

  @override
  ConsumerState<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends ConsumerState<CategoryTile> {
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: ExpansionTile(
        collapsedIconColor: AppColor.mainColor,
        title: Text(
          widget.category.category,
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
                        saveCallback: (value) {
                          ref
                              .read(homeViewModelProvider.notifier)
                              .addUrlOrUpdate(
                                  url: value,
                                  context: context,
                                  category: widget.category);
                        },
                        controller: urlController,
                        ref: ref);
                  },
                );
              },
              title: 'Add Url'),

          // Display URLs for this category
          for (int i = 0; i < widget.urlRecords.length; i++)
            GestureDetector(
              onDoubleTap: () async {
                await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    urlController.text = '';
                    return dialog(
                        context: context,
                        controller: urlController,
                        category: widget.category,
                        ref: ref,
                        editURl: widget.urlRecords[i]);
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
                                    .read(homeViewModelProvider.notifier)
                                    .deleteUrl(widget.urlRecords[i]);
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
                child: Tile(
                  url: widget.urlRecords[i],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
