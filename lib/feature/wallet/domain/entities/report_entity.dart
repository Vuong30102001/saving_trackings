class ReportEntity{
  final String userId;
  final double totalIncome;
  final double totalExpense;
  final DateTime dateTime;

  ReportEntity({
    required this.userId,
    required this.totalIncome,
    required this.totalExpense,
    required this.dateTime
  });
}