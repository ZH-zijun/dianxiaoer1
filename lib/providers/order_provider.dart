// 订单状态管理（V4.0）
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/ai_response.dart';
import '../services/db_helper.dart';
import '../services/ai_service.dart';
import '../services/offline_queue.dart';

class OrderProvider extends ChangeNotifier {
  final AiService _aiService = AiService();
  final OfflineQueueService _offlineQueue = OfflineQueueService();

  List<Order> _todayOrders = [];
  Map<int, List<OrderItem>> _orderItems = {};
  bool _isLoading = false;

  List<Order> get todayOrders => _todayOrders;
  Map<int, List<OrderItem>> get orderItemsMap => _orderItems;
  bool get isLoading => _isLoading;
  bool get hasTodayOrders => _todayOrders.isNotEmpty;

  Future<void> loadTodayOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      _todayOrders = await DbHelper.getTodayOrders();
      _orderItems = {};
      for (final order in _todayOrders) {
        if (order.id != null) {
          _orderItems[order.id!] = await DbHelper.getOrderItems(order.id!);
        }
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  List<OrderItem> getItemsForOrder(int orderId) => _orderItems[orderId] ?? [];

  Future<AiResponse> processVoiceText(String text, String apiKey) async {
    try {
      return await _aiService.parseVoiceText(text, apiKey);
    } on AiException {
      rethrow;
    }
  }

  Future<void> createOrder(AiResponse response) async {
    final tableNo = response.tableNo ?? '未知';
    final order = Order(tableNo: tableNo);
    final orderId = await DbHelper.insertOrder(order);

    final items = <OrderItem>[];
    for (final aiItem in response.items) {
      final unitPrice = aiItem.unitPrice ?? 0.0;
      items.add(OrderItem(
        orderId: orderId,
        productName: aiItem.name,
        quantity: aiItem.quantity,
        unitPrice: unitPrice,
        lineTotal: unitPrice * aiItem.quantity,
        isNew: aiItem.isNew,
      ));
    }
    await DbHelper.insertOrderItems(items);
    await loadTodayOrders();
  }

  Future<void> addItems(int orderId, AiResponse response) async {
    final items = <OrderItem>[];
    for (final aiItem in response.items) {
      final unitPrice = aiItem.unitPrice ?? 0.0;
      items.add(OrderItem(
        orderId: orderId,
        productName: aiItem.name,
        quantity: aiItem.quantity,
        unitPrice: unitPrice,
        lineTotal: unitPrice * aiItem.quantity,
        isNew: aiItem.isNew,
      ));
    }
    await DbHelper.insertOrderItems(items);
    await loadTodayOrders();
  }

  Future<void> closeOrder(int orderId) async {
    final total = await DbHelper.getOrderTotal(orderId);
    await DbHelper.updateOrderStatus(orderId, 'closed', totalAmount: total);
    await loadTodayOrders();
  }

  Future<void> enqueueOffline(String text) async {
    await _offlineQueue.enqueue(text);
  }

  Future<List<Map<String, dynamic>>> getPendingOffline() async {
    return _offlineQueue.getPending();
  }

  Future<void> markOfflineProcessed(int id) async {
    await _offlineQueue.markProcessed(id);
  }
}