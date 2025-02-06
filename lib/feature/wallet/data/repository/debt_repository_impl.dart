import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/debt_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/debt_model.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/debt_repository.dart';

import '../../domain/entities/debt_entity.dart';

class DebtRepositoryImpl implements DebtRepository{
  final DebtDataSource debtDataSource;

  DebtRepositoryImpl(this.debtDataSource);

  @override
  Future<void> addDebt(DebtEntity debt) async {
    final model = DebtModel()
        ..id = int.parse(debt.id)
        ..userId = debt.userId
        ..amount = debt.amount
        ..type = debt.type
        ..dateTime = debt.dateTime
        ..isPaid = debt.isPaid;

    await debtDataSource.addDebt(model);
  }

  @override
  Future<List<DebtEntity>> getDebts(String userId) async {
    final models = await debtDataSource.getDebts(userId);
    return models.map((result) => result.toEntity()).toList();
  }
}