import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_preview_app/common/widget/tile.dart';
import '../../../../common/const/app_colors.dart';
import '../../../common/widget/dialog.dart';
import '../../../../common/widget/custom_button.dart';
import '../view_model/home_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController urlController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ref.read(homeViewModelProvider.notifier).fetchUrl();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final urlList = ref.watch(homeViewModelProvider);
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: urlList.isEmpty
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
                    child: ReorderableListView.builder(
                      itemCount: urlList.length,
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          color: AppColor.backGroundColor,
                          child: child,
                        );
                      },
                      onReorder: (oldIndex, newIndex) => ref
                          .read(homeViewModelProvider.notifier)
                          .reorderItems(oldIndex, newIndex),
                      itemBuilder: (context, index) {
                        final url = urlList[index];
                        return Padding(
                          key: Key(url.id.toString()),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0.w,
                          ),
                          child: Slidable(
                            key: ValueKey(url),
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
                                                  .read(homeViewModelProvider
                                                      .notifier)
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
                                ]),
                            closeOnScroll: false,
                            child: GestureDetector(
                              onLongPress: () async {
                                await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    urlController.text = '';
                                    return dialog(
                                        context, urlController, ref, url);
                                  },
                                );
                              },
                              child: Tile(
                                url: url,
                              ),
                            ),
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
                urlController.text = '';
                return dialog(context, urlController, ref);
              },
            );
          },
        ),
      ),
    );
  }
}
