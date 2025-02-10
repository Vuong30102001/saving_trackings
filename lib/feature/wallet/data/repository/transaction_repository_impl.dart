import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/transaction_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/transaction_model.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/transaction_repository.dart';

import '../../domain/entities/transaction_category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../models/transaction_category_model.dart';

class TransactionRepositoryImpl implements TransactionRepository{
  final TransactionDataSource transactionDataSource;

  TransactionRepositoryImpl(this.transactionDataSource);


  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final transactionModel = TransactionModel.fromEntity(transaction);
    await transactionDataSource.addTransaction(transactionModel);
  }

  @override
  Future<List<TransactionEntity>> getTransactions(String userId) async {
    final models =  await transactionDataSource.getTransactions(userId);
    return models.map((result) => result.toEntity()).toList();
  }

  @override
  Future<void> addCategory(TransactionCategoryEntity category) async {
    final categoryModel = TransactionCategoryModel(
      userId: category.userId,
      name: category.name,
      type: category.type,
    );
    return transactionDataSource.addCategory(categoryModel);
  }

  @override
  Future<List<TransactionCategoryEntity>> getCategories(String userId, String type) async {
    final categories = await transactionDataSource.getCategories(userId, type);
    return categories
        .map((model) => TransactionCategoryEntity(
        userId: model.userId,
        name: model.name,
        type: model.type,
    )).toList();
  }
}