import 'package:any_link_preview/any_link_preview.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_preview_app/model/category_model.dart';
import 'package:url_preview_app/model/url_modell.dart';

class IsarDatabase {
  static late Isar _isar;

  static Future<void> open() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        UrlPreviewDataSchema,
        CategorySchema,
      ],
      directory: dir.path,
    );
  }

  Future<int> addUrl(Metadata metaData, String category) async {
    //Get existing category
    final existingCategory = await _isar.categorys
        .where()
        .filter()
        .categoryEqualTo(category)
        .findFirst();

    late Id id;

    if (existingCategory != null) {
      final urlModel = UrlPreviewData()
        ..title = metaData.title ?? ''
        ..desc = metaData.desc ?? ''
        ..image = metaData.image ?? ''
        ..url = metaData.url ?? ''
        ..category.value = existingCategory;
      await _isar.writeTxn(() async {
        id = await _isar.urlPreviewDatas.put(urlModel);
        await urlModel.category.save();
      });
    } else {
      final urlCategory = Category()..category = category;
      final urlModel = UrlPreviewData()
        ..title = metaData.title ?? ''
        ..desc = metaData.desc ?? ''
        ..image = metaData.image ?? ''
        ..url = metaData.url ?? ''
        ..category.value = urlCategory;

      await _isar.writeTxnSync(
        () async {
          id = _isar.urlPreviewDatas.putSync(urlModel);
        },
      );
    }

    return id;
  }

  Future<List<UrlPreviewData>> fetchAllUrls() async {
    final urls = await _isar.urlPreviewDatas.where().findAll();
    return urls;
  }

  Future<void> updateUrlModel(UrlPreviewData url, Metadata updatedURL) async {
    await _isar.writeTxn(() async {
      final urlModel = await _isar.urlPreviewDatas.get(url.id);
      if (urlModel != null) {
        urlModel
          ..title = updatedURL.title
          ..desc = updatedURL.desc
          ..image = updatedURL.image
          ..url = updatedURL.url;
        await _isar.urlPreviewDatas.put(urlModel);
      }
    });
  }

  Future<void> deleteUrl(int id) async {
    await _isar.writeTxn(() async {
      await _isar.urlPreviewDatas.delete(id);
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
