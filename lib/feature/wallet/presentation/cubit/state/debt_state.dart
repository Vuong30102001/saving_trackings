import '../../../domain/entities/debt_entity.dart';

abstract class DebtState{
  const DebtState();

  List<Object?> get props => [];
}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final List<DebtEntity> debts;
  const DebtLoaded(this.debts);

  @override
  List<Object?> get props => [debts];
}

class DebtError extends DebtState {
  final String message;
  const DebtError(this.message);

  @override
  List<Object?> get props => [message];
}
