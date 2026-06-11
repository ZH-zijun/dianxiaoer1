// 配置状态管理（V4.0）
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../services/config_service.dart';

class ConfigProvider extends ChangeNotifier {
  final ConfigService _configService = ConfigService();

  String _shopName = AppDefaults.defaultShopName;
  bool _hasPaid = AppDefaults.defaultHasPaid;
  String _apiKey = AppDefaults.defaultApiKey;
  bool _isLoaded = false;

  String get shopName => _shopName;
  bool get hasPaid => _hasPaid;
  String get apiKey => _apiKey;
  bool get isLoaded => _isLoaded;

  Future<void> loadConfig() async {
    try {
      _shopName = await _configService.getShopName();
      _hasPaid = await _configService.getHasPaid();
      _apiKey = await _configService.getApiKey();
    } catch (_) {
      // 使用默认值
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setShopName(String name) async {
    _shopName = name;
    notifyListeners();
    await _configService.setShopName(name);
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    notifyListeners();
    await _configService.setApiKey(key);
  }

  Future<void> markPaid() async {
    _hasPaid = true;
    notifyListeners();
    await _configService.setHasPaid(true);
  }
}