import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/add_transaction_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_balance_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_transaction_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/state/wallet_state.dart';

class WalletCubit extends Cubit<WalletState>{
  final AddTransactionUseCase addTransactionUseCase;
  final GetTransactionUseCase getTransactionUseCase;
  final GetBalanceUseCase getBalanceUseCase;

  WalletCubit({
    required this.addTransactionUseCase, 
    required this.getTransactionUseCase,
    required this.getBalanceUseCase,
  }) : super(WalletInitial());

  Future<void> loadWallet(String userId) async {
    emit(WalletLoading());

    // Kiểm tra xem userId có phải null không trước khi tiếp tục
    if (userId == null || userId.isEmpty) {
      emit(WalletError('User ID không hợp lệ.'));
      return;
    }

    try {
      // Lấy số dư và giao dịch từ các use case
      final balance = await getBalanceUseCase.getBalance(userId);
      final transactions = await getTransactionUseCase.getTransactions(userId);

      // Kiểm tra xem balance và transactions có null không
      if (balance == null || transactions == null) {
        emit(WalletError('Không thể lấy thông tin ví hoặc giao dịch.'));
        return;
      }

      // Emit state WalletLoaded nếu mọi thứ ổn
      emit(WalletLoaded(balance, transactions));
    } catch (e, stackTrace) {
      print('Lỗi: $e');  // Log chi tiết lỗi
      print('Stack Trace: $stackTrace');  // Log thêm stack trace để biết vị trí lỗi
      emit(WalletError('Lỗi khi tải ví: ${e.toString()}'));
    }

  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    try{
      await addTransactionUseCase.addTransaction(transaction);
      await loadWallet(transaction.userId);
    }
    catch(e){
      emit(WalletError('Error: ${e.toString()}'));
    }
  }
}