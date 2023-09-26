import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_preview_app/model/url_model.dart';
import 'package:url_preview_app/services/local/db.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, List<Url>>((ref) {
  return HomeViewModel();
});

class HomeViewModel extends StateNotifier<List<Url>> {
  HomeViewModel() : super([]);
  IsarDatabase db = IsarDatabase();
  Future<void> addUrl({required String url}) async {
    try {
      final id = await db.addUrl(url);
      Url urlRecord = Url(id: id, url: url);
      state = [...state, urlRecord];
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void fetchUrl() async {
    final url = await db.fetchAllUrls();
    state = url;
  }

  void deleteUrl(Url url) async {
    final urlList = state;
    urlList.remove(url);
    state = urlList;

    await db.deleteUrl(url.id!);
  }
}
