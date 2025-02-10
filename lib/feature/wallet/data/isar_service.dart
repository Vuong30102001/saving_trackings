import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/balance_model.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/debt_model.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/transaction_category_model.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/transaction_model.dart';

class IsarService{
  late Future<Isar> db;

  IsarService() {
    db = _initDB();
  }

  Future<Isar> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
    [TransactionModelSchema, BalanceModelSchema, DebtModelSchema, TransactionCategoryModelSchema],
    directory: dir.path);
  }
}