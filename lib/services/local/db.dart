import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_preview_app/model/url_model.dart';

class IsarDatabase {
  static late Isar _isar;

  static Future<void> open() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UrlSchema],
      directory: dir.path,
    );
  }

  Future<int> addUrl(String url) async {
    final urlModel = Url(url: url);
    late Id id;
    await _isar.writeTxn(() async {
      id = await _isar.urls.put(urlModel);
    });
    return id;
  }

  Future<List<Url>> fetchAllUrls() async {
    final urls = await _isar.urls.where().findAll();
    return urls;
  }

  Future<void> deleteUrl(int id) async {
    await _isar.writeTxn(() async {
      await _isar.urls.delete(id);
    });
  }
}
