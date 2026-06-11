// 数据库封装层（V4.0）- 所有 SQL 操作的唯一入口
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../config/constants.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/product.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, AppDefaults.dbFileName);
    return openDatabase(
      path,
      version: AppDefaults.defaultDbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE config (
        key   TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT NOT NULL UNIQUE,
        unit_price REAL NOT NULL,
        category   TEXT DEFAULT '未分类',
        created_at TEXT DEFAULT (datetime('now','localtime'))
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        table_no     TEXT NOT NULL,
        status       TEXT NOT NULL DEFAULT 'open',
        created_at   TEXT DEFAULT (datetime('now','localtime')),
        closed_at    TEXT,
        total_amount REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id     INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        quantity     INTEGER NOT NULL DEFAULT 1,
        unit_price   REAL NOT NULL,
        line_total   REAL NOT NULL,
        is_new       INTEGER DEFAULT 0,
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT,
        phone       TEXT,
        total_spent REAL DEFAULT 0.0,
        visit_count INTEGER DEFAULT 0,
        last_visit  TEXT,
        created_at  TEXT DEFAULT (datetime('now','localtime'))
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        category   TEXT NOT NULL,
        amount     REAL NOT NULL,
        note       TEXT,
        created_at TEXT DEFAULT (datetime('now','localtime'))
      )
    ''');

    await db.execute('''
      CREATE TABLE offline_queue (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        payload    TEXT NOT NULL,
        status     TEXT DEFAULT 'pending',
        created_at TEXT DEFAULT (datetime('now','localtime'))
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_orders_table_no ON orders(table_no)',
    );
    await db.execute(
      'CREATE INDEX idx_orders_status ON orders(status)',
    );
    await db.execute(
      'CREATE INDEX idx_orders_created ON orders(created_at)',
    );
    await db.execute(
      'CREATE INDEX idx_items_order ON order_items(order_id)',
    );
    await db.execute(
      'CREATE INDEX idx_offline_status ON offline_queue(status)',
    );

    // 插入默认配置
    await db.insert('config', {'key': 'shop_name', 'value': AppDefaults.defaultShopName});
    await db.insert('config', {'key': 'has_paid', 'value': AppDefaults.defaultHasPaid.toString()});
    await db.insert('config', {'key': 'api_key', 'value': AppDefaults.defaultApiKey});
    await db.insert('config', {'key': 'db_version', 'value': AppDefaults.defaultDbVersion.toString()});

    // 插入品类初始数据
    for (final p in Product.seedData) {
      await db.insert('products', {
        'name': p['name'],
        'unit_price': p['unit_price'],
        'category': p['category'],
      });
    }
  }

  static Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // ───────── config 操作 ─────────

  static Future<String?> getConfig(String key) async {
    final db = await database;
    final rows = await db.query('config', where: 'key = ?', whereArgs: [key]);
    if (rows.isEmpty) return null;
    return rows.first['value'] as String;
  }

  static Future<void> setConfig(String key, String value) async {
    final db = await database;
    await db.insert('config', {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ───────── products 操作 ─────────

  static Future<List<Product>> getAllProducts() async {
    final db = await database;
    final rows = await db.query('products', orderBy: 'id');
    return rows.map((e) => Product.fromMap(e)).toList();
  }

  static Future<Product?> getProductByName(String name) async {
    final db = await database;
    final rows = await db.query('products', where: 'name = ?', whereArgs: [name]);
    if (rows.isEmpty) return null;
    return Product.fromMap(rows.first);
  }

  static Future<List<Product>> searchProductsByName(String keyword) async {
    final db = await database;
    final rows = await db.query('products', where: 'name LIKE ?', whereArgs: ['%$keyword%']);
    return rows.map((e) => Product.fromMap(e)).toList();
  }

  static Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toMap()..remove('id'));
  }

  static Future<void> updateProductPrice(String name, double unitPrice) async {
    final db = await database;
    await db.update(
      'products',
      {'unit_price': unitPrice},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  // ───────── orders 操作 ─────────

  static Future<int> insertOrder(Order order) async {
    final db = await database;
    return db.insert('orders', order.toMap()..remove('id'));
  }

  static Future<Order?> getOrderById(int id) async {
    final db = await database;
    final rows = await db.query('orders', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Order.fromMap(rows.first);
  }

  static Future<Order?> getOpenOrderByTable(String tableNo) async {
    final db = await database;
    final rows = await db.query(
      'orders',
      where: 'table_no = ? AND status = ?',
      whereArgs: [tableNo, 'open'],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Order.fromMap(rows.first);
  }

  static Future<List<Order>> getTodayOrders() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final rows = await db.query(
      'orders',
      where: "created_at LIKE ?",
      whereArgs: ['$today%'],
      orderBy: 'created_at DESC',
    );
    return rows.map((e) => Order.fromMap(e)).toList();
  }

  static Future<void> updateOrderStatus(int id, String status, {double? totalAmount}) async {
    final db = await database;
    final values = <String, dynamic>{'status': status};
    if (status == 'closed') {
      values['closed_at'] = DateTime.now().toIso8601String();
      if (totalAmount != null) {
        values['total_amount'] = totalAmount;
      }
    }
    await db.update('orders', values, where: 'id = ?', whereArgs: [id]);
  }

  // ───────── order_items 操作 ─────────

  static Future<void> insertOrderItems(List<OrderItem> items) async {
    final db = await database;
    final batch = db.batch();
    for (final item in items) {
      batch.insert('order_items', item.toMap()..remove('id'));
    }
    await batch.commit(noResult: true);
  }

  static Future<List<OrderItem>> getOrderItems(int orderId) async {
    final db = await database;
    final rows = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
    return rows.map((e) => OrderItem.fromMap(e)).toList();
  }

  static Future<double> getOrderTotal(int orderId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(line_total) as total FROM order_items WHERE order_id = ?',
      [orderId],
    );
    final total = result.first['total'];
    if (total == null) return 0.0;
    return (total as num).toDouble();
  }

  static Future<void> updateOrderItemQuantity(int itemId, int quantity) async {
    final db = await database;
    final rows = await db.query('order_items', where: 'id = ?', whereArgs: [itemId]);
    if (rows.isEmpty) return;
    final item = OrderItem.fromMap(rows.first);
    final newLineTotal = item.unitPrice * quantity;
    await db.update(
      'order_items',
      {'quantity': quantity, 'line_total': newLineTotal},
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  static Future<void> deleteOrderItem(int itemId) async {
    final db = await database;
    await db.delete('order_items', where: 'id = ?', whereArgs: [itemId]);
  }

  // ───────── offline_queue 操作 ─────────

  static Future<void> enqueueOffline(String payload) async {
    final db = await database;
    await db.insert('offline_queue', {
      'payload': payload,
      'status': 'pending',
    });
  }

  static Future<List<Map<String, dynamic>>> getPendingOfflineItems() async {
    final db = await database;
    return db.query('offline_queue',
        where: 'status = ?', whereArgs: ['pending'], orderBy: 'created_at ASC');
  }

  static Future<void> markOfflineItem(int id, String status) async {
    final db = await database;
    await db.update('offline_queue', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  // ───────── 数据导出 ─────────

  static Future<String> exportDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return p.join(dbPath, AppDefaults.dbFileName);
  }
}
