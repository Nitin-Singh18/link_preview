import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_preview_app/model/category_model.dart';
import 'package:url_preview_app/model/url_model.dart';

class IsarDatabase {
  static late Isar _isar;

  static Future<void> open() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UrlSchema, CategorySchema],
      directory: dir.path,
    );
  }

  Future<int> addUrl(String url, String category) async {
    final existingCategory = await _isar.categorys
        .where()
        .filter()
        .categoryEqualTo(category)
        .findFirst();

    late Id id;

    if (existingCategory != null) {
      final urlModel = Url()
        ..url = url
        ..category.value = existingCategory;
      await _isar.writeTxn(() async {
        id = await _isar.urls.put(urlModel);
        await urlModel.category.save();
      });
    } else {
      final urlCategory = Category()..category = category;
      final urlModel = Url()
        ..url = url
        ..category.value = urlCategory;

      await _isar.writeTxnSync(
        () async {
          id = _isar.urls.putSync(urlModel);
        },
      );
    }

    return id;
  }

  Future<List<Url>> fetchAllUrls() async {
    final urls = await _isar.urls.where().findAll();
    return urls;
  }

  Future<void> updateUrlModel(Url url, String updatedURL) async {
    await _isar.writeTxn(() async {
      final urlModel = await _isar.urls.get(url.id);
      if (urlModel != null) {
        urlModel.url = updatedURL;
        await _isar.urls.put(urlModel);
      }
    });
  }

  Future<void> deleteUrl(int id) async {
    await _isar.writeTxn(() async {
      await _isar.urls.delete(id);
    });
  }

  Future<int> insertCategory(String category) async {
    final categoryRecord = Category()..category = category;
    late final int id;
    await _isar.writeTxn(
      () async {
        id = await _isar.categorys.put(categoryRecord);
      },
    );
    return id;
  }

  Future<void> updateCategory(
      Category category, String updatedCategoryName) async {
    final item = await _isar.categorys.get(category.id);

    item!.category = updatedCategoryName;
    await _isar.writeTxn(
      () async {
        await _isar.categorys.put(item);
      },
    );
  }

  Future<List<Category>> fetchAllCategorys() async {
    final categorys = await _isar.categorys.where().findAll();

    return categorys;
  }
}
