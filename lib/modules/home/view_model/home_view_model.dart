import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_preview_app/common/const/utils.dart';
import 'package:url_preview_app/model/url_modell.dart';
import 'package:url_preview_app/services/local/db.dart';

import '../../../model/category_model.dart';

class HomeState {
  final List<Category> categoryList;
  final List<UrlPreviewData> urlRecords;

  HomeState({required this.categoryList, required this.urlRecords});

  HomeState copyWith({
    List<Category>? categoryList,
    List<UrlPreviewData>? urlRecords,
  }) {
    return HomeState(
      categoryList: categoryList ?? this.categoryList,
      urlRecords: urlRecords ?? this.urlRecords,
    );
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState(categoryList: [], urlRecords: []));

  IsarDatabase db = IsarDatabase();

  Future<void> addUrlOrUpdate(
      {required String url,
      required BuildContext context,
      required Category category,
      UrlPreviewData? editUrl}) async {
    //Check if the url is valid
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      debugPrint('Invalid URL: $url');
      snackBar('Invalid URL. Please enter a valid URL.', context);
      return; // Exit the function if the URL is invalid
    }
    Metadata? metaData = await getMetaData(url);
    if (metaData == null) {
      return;
    }

    try {
      late UrlPreviewData urlRecord;
      if (editUrl != null) {
        urlRecord = UrlPreviewData()
          ..id = editUrl.id
          ..title = metaData.title
          ..desc = metaData.desc
          ..image = metaData.image
          ..url = metaData.url
          ..category.value = category;
        await db.updateUrlModel(editUrl, metaData);

        List<UrlPreviewData> urlList = state.urlRecords;

        final index =
            urlList.indexWhere((element) => element.id == urlRecord.id);
        urlList[index] = urlRecord;
        state = state.copyWith(urlRecords: urlList);
      } else {
        final id = await db.addUrl(metaData, category.category);
        urlRecord = UrlPreviewData()
          ..id = id
          ..title = metaData.title
          ..desc = metaData.desc
          ..image = metaData.image
          ..url = metaData.url
          ..category.value = category;

        final urlRecords = [...state.urlRecords, urlRecord];
        state = state.copyWith(urlRecords: urlRecords);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<Metadata?> getMetaData(String link) async {
    Metadata? metadata =
        await AnyLinkPreview.getMetadata(link: link, cache: null);
    return metadata;
  }

  void fetchUrl() async {
    final urls = await db.fetchAllUrls();
    state = state.copyWith(urlRecords: urls);
  }

  void deleteUrl(UrlPreviewData url) async {
    await db.deleteUrl(url.id);
    final urlList = state.urlRecords;
    urlList.remove(url);
    final updateUrlList =
        state.urlRecords.where((urlRecord) => urlRecord != url).toList();
    state = state.copyWith(urlRecords: updateUrlList);
  }

  void reorderItems(int oldIndex, int newIndex) {
    final items = state.urlRecords;
    if (oldIndex < newIndex) {
      newIndex--;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = state.copyWith(urlRecords: items);
  }

  void addCategory(String category) async {
    final id = await db.insertCategory(category);

    final Category categoryRecord = Category()
      ..id = id
      ..category = category;

    final updatedCategories = [...state.categoryList];
    updatedCategories.add(categoryRecord);

    state = state.copyWith(categoryList: updatedCategories);
  }

  void fetchCategories() async {
    state = state.copyWith(categoryList: await db.fetchAllCategorys());
    fetchUrl();
  }

  List<UrlPreviewData> getCurrentCategorUrl(Category category) {
    final List<UrlPreviewData> urls = state.urlRecords.where((element) {
      return element.category.value?.id == category.id;
    }).toList();
    return urls.reversed.toList();
  }
}
