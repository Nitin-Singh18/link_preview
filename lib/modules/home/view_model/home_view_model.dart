import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_preview_app/common/const/utils.dart';
import 'package:url_preview_app/model/url_model.dart';
import 'package:url_preview_app/services/local/db.dart';

import '../../../model/category_model.dart';

class HomeState {
  final List<Category> categoryList;
  final List<Url> urlRecords;

  HomeState({required this.categoryList, required this.urlRecords});

  HomeState copyWith({
    List<Category>? categoryList,
    List<Url>? urlRecords,
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
      Url? editUrl}) async {
    //Check if the url is valid
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      debugPrint('Invalid URL: $url');
      snackBar('Invalid URL. Please enter a valid URL.', context);
      return; // Exit the function if the URL is invalid
    }
    try {
      late Url urlRecord;
      if (editUrl != null) {
        await db.updateUrlModel(
          editUrl,
          url,
        );
        urlRecord = Url()
          ..id = editUrl.id
          ..url = url
          ..category.value = category;

        List<Url> urlList = state.urlRecords;

        final index =
            urlList.indexWhere((element) => element.id == urlRecord.id);
        urlList[index] = urlRecord;
        state = state.copyWith(urlRecords: urlList);
        fetchUrl();
      } else {
        final id = await db.addUrl(url, category.category);

        urlRecord = Url()
          ..id = id
          ..url = url
          ..category.value = category;
        final urlRecords = [...state.urlRecords, urlRecord];
        state = state.copyWith(urlRecords: urlRecords);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void fetchUrl() async {
    final urls = await db.fetchAllUrls();
    state = state.copyWith(urlRecords: urls);
  }

  void deleteUrl(Url url) async {
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

  List<Url> getCurrentCategorUrl(Category category) {
    final List<Url> urls = state.urlRecords.where((element) {
      return element.category.value?.id == category.id;
    }).toList();
    return urls;
  }
}
