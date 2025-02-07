import 'package:equatable/equatable.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/balance_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';

abstract class WalletState extends Equatable{
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final BalanceEntity balanceEntity;
  final List<TransactionEntity> transactions;

  const WalletLoaded(this.balanceEntity, this.transactions);

  @override
  List<Object?> get props => [balanceEntity, transactions];
}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

class WalletTransactionSuccess extends WalletState {
  final String successMessage;

  const WalletTransactionSuccess(this.successMessage);

  @override
  List<Object?> get props => [successMessage];
}
