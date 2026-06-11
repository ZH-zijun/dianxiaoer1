// AI 响应模型（DeepSeek JSON 解析）
class AiResponseItem {
  final String name;
  final int quantity;
  final double? unitPrice;
  final bool isNew;

  const AiResponseItem({
    required this.name,
    required this.quantity,
    this.unitPrice,
    this.isNew = false,
  });

  factory AiResponseItem.fromJson(Map<String, dynamic> json) => AiResponseItem(
    name: json['name'] as String,
    quantity: (json['quantity'] as num).toInt(),
    unitPrice: (json['unit_price'] as num?)?.toDouble(),
    isNew: json['is_new'] as bool? ?? false,
  );
}

enum AiAction {
  newOrder,
  addItems,
  closeOrder,
  updateItem,
  removeItem,
  queryPrice,
  setPrice,
  unknown,
}

class AiResponse {
  final AiAction action;
  final String? tableNo;
  final List<AiResponseItem> items;
  final double? total;
  final String message;

  const AiResponse({
    required this.action,
    this.tableNo,
    this.items = const [],
    this.total,
    this.message = '',
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    final actionStr = json['action'] as String? ?? '';
    AiAction action;
    switch (actionStr) {
      case 'new_order':
        action = AiAction.newOrder;
      case 'add_items':
        action = AiAction.addItems;
      case 'close_order':
        action = AiAction.closeOrder;
      case 'update_item':
        action = AiAction.updateItem;
      case 'remove_item':
        action = AiAction.removeItem;
      case 'query_price':
        action = AiAction.queryPrice;
      case 'set_price':
        action = AiAction.setPrice;
      default:
        action = AiAction.unknown;
    }

    final itemsRaw = json['items'] as List<dynamic>? ?? [];
    final items = itemsRaw
        .map((e) => AiResponseItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return AiResponse(
      action: action,
      tableNo: json['table_no'] as String?,
      items: items,
      total: (json['total'] as num?)?.toDouble(),
      message: json['message'] as String? ?? '',
    );
  }

  bool get isNewOrder => action == AiAction.newOrder;
  bool get isAddItems => action == AiAction.addItems;
  bool get isCloseOrder => action == AiAction.closeOrder;
  bool get isSetPrice => action == AiAction.setPrice;
  bool get hasNewProduct => items.any((item) => item.isNew);
}
