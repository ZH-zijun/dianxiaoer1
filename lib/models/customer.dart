// 客户模型
class Customer {
  final int? id;
  final String? name;
  final String? phone;
  final double totalSpent;
  final int visitCount;
  final String? lastVisit;
  final String? createdAt;

  const Customer({
    this.id,
    this.name,
    this.phone,
    this.totalSpent = 0.0,
    this.visitCount = 0,
    this.lastVisit,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    if (name != null) 'name': name,
    if (phone != null) 'phone': phone,
    'total_spent': totalSpent,
    'visit_count': visitCount,
    if (lastVisit != null) 'last_visit': lastVisit,
    if (createdAt != null) 'created_at': createdAt,
  };

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    id: map['id'] as int?,
    name: map['name'] as String?,
    phone: map['phone'] as String?,
    totalSpent: (map['total_spent'] as num?)?.toDouble() ?? 0.0,
    visitCount: map['visit_count'] as int? ?? 0,
    lastVisit: map['last_visit'] as String?,
    createdAt: map['created_at'] as String?,
  );
}
