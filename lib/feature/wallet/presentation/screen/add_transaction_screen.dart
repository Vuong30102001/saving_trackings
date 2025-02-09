import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/cubit/wallet_cubit.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/state/wallet_state.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/wallet_screen.dart';

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
        elevation: 4,
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        builder: (context, state){
          if(state is WalletLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số tiền',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.w),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Nhập số tiền',
                      prefixIcon: Icon(Icons.attach_money, color: Colors.green,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r)
                      )
                  ),
                ),
                SizedBox(height: 20.w),
                Text(
                  'Loại giao dịch',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.w,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TransactionType>(
                        value: _selectedType,
                        isExpanded: true,
                        items: TransactionType.values
                            .map((type) => DropdownMenuItem(
                            value: type,
                            child: Row(
                              children: [
                                Icon(
                                  type == TransactionType.income
                                      ? Icons.add_circle
                                      : type == TransactionType.expense
                                      ? Icons.remove_circle
                                      : type == TransactionType.lend
                                      ? Icons.monetization_on
                                      : Icons.money_off_sharp,
                                  color: type == TransactionType.income
                                      ? Colors.green
                                      : type == TransactionType.expense
                                      ? Colors.red
                                      : type == TransactionType.lend
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: 10.w,),
                                Text(type.name),
                              ],
                            )
                        )).toList(),
                        onChanged: (value){
                          setState(() {
                            _selectedType = value!;
                          });
                        }
                    ),
                  ),
                ),
                SizedBox(height: 20.w,),
                Center(
                  child: ElevatedButton(
                      onPressed: _saveTransaction,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 32.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                  ),
                )
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is WalletTransactionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage), backgroundColor: Colors.green),
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
      ),
    );
  }
}
