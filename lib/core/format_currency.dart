import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final format = NumberFormat('#,### đ', 'vi_VN');
  if(amount < 0){
    return '-${format.format(amount.abs())}';
  }
  return format.format(amount);
}