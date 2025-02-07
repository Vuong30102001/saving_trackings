import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/cubit/wallet_cubit.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/state/wallet_state.dart';
import 'package:saving_trackings_flutter/core/format_currency.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/add_transaction_screen.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/transaction_history_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isBalanceHidden = true;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print("Người dùng chưa đăng nhập!");
        } else {
          final userId = user.uid;
          print("User ID: $userId");
          if(mounted){
            context.read<WalletCubit>().loadWallet(userId);
          }
        }
      });
    });
  }

  void _onItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.email?.split("@")[0] ?? 'Guest';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text(
          'Hello $userName',
          style: TextStyle(
              fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: (){
                context.go('/signIn');
              }, 
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: IndexedStack( // Hold the Bottom Navigation bar
        index: _currentIndex,
        children: [
          BlocBuilder<WalletCubit, WalletState>(
              builder: (context, state){
                if(state is WalletLoading){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if(state is WalletLoaded){
                  double totalIncome = 0;
                  double totalExpense = 0;

                  for (var transaction in state.transactions) {
                    if (transaction.type == TransactionType.income) {
                      totalIncome += transaction.amount;
                    } else if (transaction.type == TransactionType.expense) {
                      totalExpense += transaction.amount;
                    }
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                          ),
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tổng số dư >',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                      isBalanceHidden ? '***.*** đ' : formatCurrency(state.balanceEntity.amount),
                                      style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        isBalanceHidden = !isBalanceHidden;
                                      });
                                    },
                                    icon: Icon(
                                      isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                                      size: 30.sp,
                                    )
                                )
                              ]
                          ),

                        ),
                      ),
                      Container(
                          height: 450.w,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: Offset(0, 3),
                                )
                              ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tình hình thu chi',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  height: 350,
                                  width: 300,
                                  child: PieChart(
                                      PieChartData(
                                          sections: [
                                            PieChartSectionData(
                                              value: totalIncome,
                                              color: Colors.green,
                                              showTitle: false, //Hidden value
                                              radius: 80,
                                            ),
                                            PieChartSectionData(
                                              value: totalExpense,
                                              color: Colors.red,
                                              showTitle: false,
                                              radius: 80,
                                            ),
                                          ]
                                      )
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.circle, color: Colors.green,),
                                          SizedBox(width: 50.w,),
                                          Text('Thu tiền', style: TextStyle(fontSize: 18),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.circle, color: Colors.red,),
                                          SizedBox(width: 50.w,),
                                          Text('Chi tiền', style: TextStyle(fontSize: 18),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                        onPressed: (){
                                          context.go('/transactionHistoryScreen');
                                        },
                                        child: Text(
                                          'Lịch sử giao dịch >',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        )
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      )
                    ],
                  );
                }
                else if(state is WalletError){
                  print("Lỗi: ${state.message}");
                  return Center(child: Text(state.message),);
                }
                return Container();
              }
          ),
          const AddTransactionScreen(),
          const TransactionHistoryScreen(),
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting'
          )
        ],
      ),
    );
  }
}
