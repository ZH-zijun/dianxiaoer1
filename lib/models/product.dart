// 品类模型
class Product {
  final int? id;
  final String name;
  final double unitPrice;
  final String category;
  final String? createdAt;

  const Product({
    this.id,
    required this.name,
    required this.unitPrice,
    this.category = '未分类',
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'unit_price': unitPrice,
    'category': category,
    if (createdAt != null) 'created_at': createdAt,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'] as int?,
    name: map['name'] as String,
    unitPrice: (map['unit_price'] as num).toDouble(),
    category: map['category'] as String? ?? '未分类',
    createdAt: map['created_at'] as String?,
  );

  Product copyWith({
    int? id,
    String? name,
    double? unitPrice,
    String? category,
    String? createdAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    unitPrice: unitPrice ?? this.unitPrice,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
  );

  static const List<Map<String, dynamic>> seedData = [
    {'name': '羊肉串', 'unit_price': 2.0, 'category': '烤串'},
    {'name': '肉筋儿', 'unit_price': 2.0, 'category': '烤串'},
    {'name': '板筋', 'unit_price': 2.0, 'category': '烤串'},
    {'name': '鸡翅', 'unit_price': 8.0, 'category': '烤串'},
    {'name': '蚕蛹', 'unit_price': 8.0, 'category': '烤串'},
    {'name': '烤饼', 'unit_price': 2.0, 'category': '主食'},
    {'name': '啤酒', 'unit_price': 6.0, 'category': '酒水'},
    {'name': '饮料', 'unit_price': 4.0, 'category': '酒水'},
  ];
}
