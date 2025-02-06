import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/cubit/wallet_cubit.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  TransactionType  _selectedType = TransactionType.income;

  void _saveTransaction() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if(userId == null) return;

    final transaction = TransactionEntity(
        id: DateTime.now().millisecond.toString(),
        userId: userId,
        type: _selectedType,
        amount: double.tryParse(_amountController.text) ?? 0,
        dateTime: DateTime.now(),
    );

    context.read<WalletCubit>().addTransaction(transaction);
    Future.delayed(Duration(milliseconds: 100), (){
      if(mounted){
        context.go('/walletScreen');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Nhập số tiền'),
            ),
            DropdownButton<TransactionType>(
              value: _selectedType,
                items: TransactionType.values
                  .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                )).toList(),
                onChanged: (value){
                  setState(() {
                    _selectedType = value!;
                  });
                }
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: _saveTransaction,
                child: Text('Save')
            )
          ],
        ),
      ),
    );
  }
}
