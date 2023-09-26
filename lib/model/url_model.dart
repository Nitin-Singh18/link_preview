import 'package:isar/isar.dart';

part 'url_model.g.dart';

@collection
class Url {
  Id? id = Isar.autoIncrement;

  late String url;

  Url({this.id, required this.url});
}
