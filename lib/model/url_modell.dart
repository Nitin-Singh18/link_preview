import 'package:isar/isar.dart';
import 'package:url_preview_app/model/category_model.dart';

part 'url_modell.g.dart';

@collection
class Url {
  Id id = Isar.autoIncrement;

  String? title;

  String? desc;

  String? image;

  String? url;

  final category = IsarLink<Category>();
}
