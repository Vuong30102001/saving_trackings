import 'package:saving_trackings_flutter/feature/wallet/domain/entities/debt_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/debt_repository.dart';

class GetDebtUseCase{
  final DebtRepository debtRepository;
  GetDebtUseCase({required this.debtRepository});

  Future<List<DebtEntity>> getDebts(String userId) async {
    return await debtRepository.getDebts(userId);
  }
}