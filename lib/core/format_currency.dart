import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final format = NumberFormat('#,### đ', 'vi_VN');
  return format.format(amount);
}