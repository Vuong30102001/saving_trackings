import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/cubit/wallet_cubit.dart';

import '../../domain/entities/transaction_entity.dart';
import '../cubit/state/wallet_state.dart';
import 'package:saving_trackings_flutter/core/format_currency.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.go('/walletScreen');
              },
              color: Colors.white,
            ),
            Spacer(),
            Text(
              'Lịch sử giao dịch',
              style: TextStyle(
                  color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              color: Colors.white,
            ),
            // Biểu tượng bên phải thứ hai
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state){
            if(state is WalletLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(state is WalletLoaded){
              double totalIncome = 0;
              double totalExpense = 0;

              for(var transaction in state.transactions){
                if(transaction.type == TransactionType.income){
                  totalIncome += transaction.amount;
                }
                if(transaction.type == TransactionType.expense){
                  totalExpense += transaction.amount;
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1)
                    ),
                    child: Center(
                      child: TextButton(
                          onPressed: (){

                          },
                          child: Text(
                            'Tháng này >',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18.sp,
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 5.w,),
                  Container(
                    height: 80.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Tổng thu',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatCurrency(totalIncome),
                                  style: TextStyle(fontSize: 16, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Divider (đường kẻ)
                        Container(
                          width: 1.w,
                          height: 80.w,
                          color: Colors.grey,
                        ),
                        // Bên phải: Tổng chi
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Tổng chi',
                                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatCurrency(totalExpense),
                                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.w,),
                  Container(
                      height: 300.w,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BlocBuilder<WalletCubit, WalletState>(
                            builder: (context, state){
                              if(state is WalletLoading){
                                return Center(child: CircularProgressIndicator(),);
                              }
                              else if(state is WalletLoaded){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tình hình thu chi',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: state.transactions.length,
                                        itemBuilder: (context, index){
                                          final transaction = state.transactions[index];
                                          return ListTile(
                                            leading: Icon(
                                              transaction.type == TransactionType.income
                                                  ? Icons.arrow_circle_down
                                                  : Icons.arrow_circle_up,
                                              color: transaction.type == TransactionType.income
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 30.sp,
                                            ),
                                            title: Text(
                                              transaction.type.toString(),
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              '${transaction.dateTime}',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                            trailing: Text(
                                              '${transaction.amount} đ',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: transaction.type == TransactionType.income
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                              else if(state is WalletError){
                                return Center(child: Text(state.message),);
                              }
                              return Container();
                            }
                        ),
                      )
                  )
                ],
              );
            }
            else if(state is WalletError){
              return Center(child: Text(state.message),);
            }
            return Container();
          }
      )
    );
  }
}
