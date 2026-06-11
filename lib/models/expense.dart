// 支出模型
class Expense {
  final int? id;
  final String category;
  final double amount;
  final String? note;
  final String? createdAt;

  const Expense({
    this.id,
    required this.category,
    required this.amount,
    this.note,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'category': category,
    'amount': amount,
    if (note != null) 'note': note,
    if (createdAt != null) 'created_at': createdAt,
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'] as int?,
    category: map['category'] as String,
    amount: (map['amount'] as num).toDouble(),
    note: map['note'] as String?,
    createdAt: map['created_at'] as String?,
  );
}
