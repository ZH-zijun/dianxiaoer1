// 订单模型
class Order {
  final int? id;
  final String tableNo;
  final String status;
  final String? createdAt;
  final String? closedAt;
  final double totalAmount;

  const Order({
    this.id,
    required this.tableNo,
    this.status = 'open',
    this.createdAt,
    this.closedAt,
    this.totalAmount = 0.0,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'table_no': tableNo,
    'status': status,
    if (createdAt != null) 'created_at': createdAt,
    if (closedAt != null) 'closed_at': closedAt,
    'total_amount': totalAmount,
  };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
    id: map['id'] as int?,
    tableNo: map['table_no'] as String,
    status: map['status'] as String? ?? 'open',
    createdAt: map['created_at'] as String?,
    closedAt: map['closed_at'] as String?,
    totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
  );

  Order copyWith({
    int? id,
    String? tableNo,
    String? status,
    String? createdAt,
    String? closedAt,
    double? totalAmount,
  }) => Order(
    id: id ?? this.id,
    tableNo: tableNo ?? this.tableNo,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    closedAt: closedAt ?? this.closedAt,
    totalAmount: totalAmount ?? this.totalAmount,
  );
}
