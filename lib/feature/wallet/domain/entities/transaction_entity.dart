enum TransactionType{
  income,
  expense,
  lend,
  borrow,
}

class TransactionEntity{
  final String id;
  final String userId;
  final TransactionType type;
  final String category;
  final double amount;
  final DateTime dateTime;

  TransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    required this.dateTime
  });
}