// 离线队列管理（V4.0）
import 'db_helper.dart';

class OfflineQueueService {
  Future<void> enqueue(String text) async {
    try {
      await DbHelper.enqueueOffline(text);
    } catch (_) {
      // 入队失败不影响用户操作
    }
  }

  Future<List<Map<String, dynamic>>> getPending() async {
    try {
      return await DbHelper.getPendingOfflineItems();
    } catch (_) {
      return [];
    }
  }

  Future<void> markProcessed(int id) async {
    try {
      await DbHelper.markOfflineItem(id, 'processed');
    } catch (_) {}
  }

  Future<void> markFailed(int id) async {
    try {
      await DbHelper.markOfflineItem(id, 'failed');
    } catch (_) {}
  }
}
