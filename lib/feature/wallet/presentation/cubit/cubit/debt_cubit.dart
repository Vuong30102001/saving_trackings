import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/add_debt_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_debt_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/state/debt_state.dart';

import '../../../domain/entities/debt_entity.dart';

class DebtCubit extends Cubit<DebtState>{
  final AddDebtUseCase addDebtUseCase;
  final GetDebtUseCase getDebtUseCase;
  DebtCubit({required this.addDebtUseCase, required this.getDebtUseCase}) : super(DebtInitial());

  Future<void> loadDebts(String userId) async {
    emit(DebtLoading());
    try {
      final debts = await getDebtUseCase.getDebts(userId);
      emit(DebtLoaded(debts));
    } catch (e) {
      emit(DebtError("Error: ${e.toString()}"));
    }
  }

  Future<void> addDebt(DebtEntity debt) async {
    try {
      await addDebtUseCase.addDebt(debt);
      await loadDebts(debt.userId);
    } catch (e) {
      emit(DebtError("Error: ${e.toString()}"));
    }
  }
}