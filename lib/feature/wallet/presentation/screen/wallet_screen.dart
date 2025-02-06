import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/cubit/wallet_cubit.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/state/wallet_state.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('State Wallet'),
        actions: [
          IconButton(
              onPressed: (){
                context.go('/signIn');
              }, 
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state){
            if(state is WalletLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(state is WalletLoaded){
              return Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Số dư: ${state.balanceEntity.amount} VNĐ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index){
                        final transaction = state.transactions[index];
                        return ListTile(
                          title: Text(transaction.type.toString()),
                          subtitle: Text('${transaction.amount} VNĐ - ${transaction.dateTime}'),
                        );
                      },
                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.go('/addTransactionScreen');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
