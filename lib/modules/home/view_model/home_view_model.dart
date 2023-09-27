import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_preview_app/common/const/utils.dart';
import 'package:url_preview_app/model/url_model.dart';
import 'package:url_preview_app/services/local/db.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, List<Url>>((ref) {
  return HomeViewModel();
});

class HomeViewModel extends StateNotifier<List<Url>> {
  HomeViewModel() : super([]);
  IsarDatabase db = IsarDatabase();
  Future<void> addUrlOrUpdate(
      {required String url,
      required BuildContext context,
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

        urlRecord = Url(id: editUrl.id, url: url);
        final urlList = state;

        final index =
            urlList.indexWhere((element) => element.id == urlRecord.id);
        urlList[index] = urlRecord;
        state = urlList;
        fetchUrl();
      } else {
        final id = await db.addUrl(url);
        urlRecord = Url(id: id, url: url);
        state = [...state, urlRecord];
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void fetchUrl() async {
    final url = await db.fetchAllUrls();
    state = url;
  }

  void deleteUrl(Url url) async {
    await db.deleteUrl(url.id!);
    final urlList = state;
    urlList.remove(url);
    state = state.where((urlRecord) => urlRecord != url).toList();
  }

  void reorderItems(int oldIndex, int newIndex) {
    final items = state;
    if (oldIndex < newIndex) {
      newIndex--;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = items;
  }
}
