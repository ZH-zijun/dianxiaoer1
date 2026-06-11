// 订单明细模型
class OrderItem {
  final int? id;
  final int orderId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final bool isNew;

  const OrderItem({
    this.id,
    required this.orderId,
    required this.productName,
    this.quantity = 1,
    required this.unitPrice,
    required this.lineTotal,
    this.isNew = false,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'order_id': orderId,
    'product_name': productName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'line_total': lineTotal,
    'is_new': isNew ? 1 : 0,
  };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    id: map['id'] as int?,
    orderId: map['order_id'] as int,
    productName: map['product_name'] as String,
    quantity: map['quantity'] as int? ?? 1,
    unitPrice: (map['unit_price'] as num).toDouble(),
    lineTotal: (map['line_total'] as num).toDouble(),
    isNew: (map['is_new'] as int?) == 1,
  );

  OrderItem copyWith({
    int? id,
    int? orderId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? lineTotal,
    bool? isNew,
  }) => OrderItem(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    lineTotal: lineTotal ?? this.lineTotal,
    isNew: isNew ?? this.isNew,
  );
}
