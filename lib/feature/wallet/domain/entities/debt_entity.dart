class DebtEntity{
  final String id;
  final String userId;
  final String type;
  final double amount;
  final DateTime dateTime;
  final bool isPaid;

  DebtEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.dateTime,
    required this.isPaid
  });
}