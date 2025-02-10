import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_category_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/transaction_repository.dart';

class GetCategoriesUseCase{
  final TransactionRepository transactionRepository;
  GetCategoriesUseCase({required this.transactionRepository});

  Future<List<TransactionCategoryEntity>> getCategories(String userId, String type) async {
    return await transactionRepository.getCategories(userId, type);
  }
}