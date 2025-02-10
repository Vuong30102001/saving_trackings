import 'package:isar/isar.dart';

part 'transaction_category_model.g.dart';

@collection
class TransactionCategoryModel {
  Id id = Isar.autoIncrement;
  late String userId;
  late String name;
  late String type;

  TransactionCategoryModel({
    required this.userId,
    required this.name,
    required this.type,
  });
}
