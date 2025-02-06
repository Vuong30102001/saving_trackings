import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/balance_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/balance_repository.dart';

import '../../domain/entities/balance_entity.dart';

class BalanceRepositoryImpl implements BalanceRepository{
  final BalanceDataSource balanceDataSource;

  BalanceRepositoryImpl(this.balanceDataSource);

  @override
  Future<BalanceEntity> getBalance(String userId) async {
    final model = await balanceDataSource.getBalance(userId);

    if (model == null) {
      throw Exception('Không thể tải thông tin ví, dữ liệu trả về là null');
    }

    return model.toEntity();
  }


  @override
  Future<void> updateBalance(String userId, double newBalance) async {
    await balanceDataSource.updateBalance(userId, newBalance);
  }

  @override
  Future<void> saveBalance(String userId, double amount) async {
    await balanceDataSource.saveBalance(userId, amount);
  }
}