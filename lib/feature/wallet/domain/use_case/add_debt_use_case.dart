import 'package:saving_trackings_flutter/feature/wallet/domain/entities/debt_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/debt_repository.dart';

class AddDebtUseCase{
  final DebtRepository debtRepository;
  AddDebtUseCase({required this.debtRepository});

  Future<void> addDebt(DebtEntity debt) async {
    await debtRepository.addDebt(debt);
  }
}