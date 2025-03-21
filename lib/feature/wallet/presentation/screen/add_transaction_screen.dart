import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_category_entity.dart';
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
  //
  final _categoryController = TextEditingController();
  TransactionType  _selectedType = TransactionType.income;
  String? _selectedCategory;
  List<String> _categories = [
    'Ăn uống',
    'Mua sắm',
    'Giải trí',
    'Du lịch',
  ];
  final List<IconData> _categoryIcons = [
    Icons.fastfood, // Đồ ăn
    Icons.shopping_cart, // Mua sắm
    Icons.movie, // Giải trí
    Icons.directions_car, // Du lịch
  ];

  void _saveTransaction() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final walletCubit = context.read<WalletCubit>();

    final transaction = TransactionEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: _selectedType,
      amount: double.tryParse(_amountController.text) ?? 0,
      category: _selectedCategory!,
      dateTime: DateTime.now(),
    );

    final category = TransactionCategoryEntity(
      userId: userId,
      name: _categoryController.text,
      type: _selectedType.toString(),
    );

    _amountController.clear();

    // Chạy trong một microtask để tránh lag
    Future.microtask(() => _saveData(walletCubit, transaction, category));
  }

  Future<void> _saveData(
      WalletCubit walletCubit,
      TransactionEntity transaction,
      TransactionCategoryEntity category) async {
    await walletCubit.addTransaction(transaction);
    await walletCubit.addCategory(category);
    print("Transaction & Category saved.");
  }


  void _addNewCategory() {
    if(_categoryController.text.isNotEmpty){
      final newCategory = _categoryController.text;
      setState(() {
        _categories.add(newCategory);
        _selectedCategory = newCategory;
      });
      _categoryController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Transaction',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        elevation: 2, // Giảm đổ bóng để trông tinh tế hơn
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/walletScreen'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: () {
              // TODO: Xử lý lưu giao dịch
              _saveTransaction();
            },
          ),
        ],
      ),

      body: BlocConsumer<WalletCubit, WalletState>(
        builder: (context, state){
          if(state is WalletLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                  Text('Danh mục', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.w),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                            isExpanded: true,
                            items: _categories.map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            )).toList(),
                            onChanged: (value){
                            setState(() {
                              _selectedCategory = value;
                            });
                            }
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Thêm danh mục mới'),
                              content: TextField(
                                controller: _categoryController,
                                decoration: InputDecoration(hintText: 'Nhập tên danh mục'),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
                                TextButton(onPressed: _addNewCategory, child: Text('Thêm')),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w,),
                  SizedBox(
                    height: 180.w,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                _categoryController.text = _categories[index];
                                _selectedCategory = _categories[index];
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: Offset(2, 4)
                                  )
                                ]
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _categoryIcons[index % _categoryIcons.length],
                                    color: Colors.blueAccent,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _categories[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                  SizedBox(height: 8.w,),
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
