import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_category_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/transaction_repository.dart';

class AddCategoryUseCase{
  final TransactionRepository transactionRepository;
  AddCategoryUseCase({required this.transactionRepository});

  Future<void> addCategory(TransactionCategoryEntity categoryEntity) async {
    return await transactionRepository.addCategory(categoryEntity);
  }
}