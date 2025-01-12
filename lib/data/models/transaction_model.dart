class TransactionModel {
  final String name; 
  final String originator; 
  final double amount; 
  final String date;
  final List<String>? paymentMethods;

  TransactionModel({
    required this.name,
    required this.originator,
    required this.amount,
    required this.date,
     this.paymentMethods,
  });


  bool isIncome() => amount > 0;

  @override
  String toString() {
    return '$name - $originator: ${isIncome() ? '+' : ''}\$${amount.toStringAsFixed(2)}';
  }
}
