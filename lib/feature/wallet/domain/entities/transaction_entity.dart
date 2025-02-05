enum TransactionType{
  income,
  expense,
  lend,
  borrow,
}

class TransactionEntity{
  final String id;
  final TransactionType userId;
  final String type;
  final double amount;
  final DateTime dateTime;

  TransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.dateTime
  });
}