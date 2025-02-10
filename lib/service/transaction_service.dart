import 'dart:isolate';
import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/balance_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/transaction_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/isar_service.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/repository/transaction_repository_impl.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_category_entity.dart';

void saveTransactionIsolate(Map<String, dynamic> data) async {
  final SendPort sendPort = data['port'];

  // Khởi tạo IsarService bên trong Isolate
  final isarService = IsarService();
  final balanceDataSource = BalanceDataSourceImpl(isarService);
  final transactionDataSource = TransactionDataSourceImpl(
      isarService,
      balanceDataSource
  );
  final transactionRepository = TransactionRepositoryImpl(transactionDataSource);

  final transaction = TransactionEntity(
    id: data['transaction']['id'],
    userId: data['transaction']['userId'],
    type: data['transaction']['type'],
    amount: data['transaction']['amount'],
    category: data['transaction']['category'],
    dateTime: DateTime.parse(data['transaction']['dateTime']),
  );

  final category = TransactionCategoryEntity(
    userId: data['category']['userId'],
    name: data['category']['name'],
    type: data['category']['type'],
  );

  await transactionRepository.addTransaction(transaction);
  await transactionRepository.addCategory(category);

  // Gửi tín hiệu hoàn thành về Main Isolate
  sendPort.send(true);
}
