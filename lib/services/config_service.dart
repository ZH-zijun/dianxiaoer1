// 配置读写服务（V4.0）
import '../config/constants.dart';
import 'db_helper.dart';

class ConfigService {
  Future<String> getShopName() async {
    final value = await DbHelper.getConfig('shop_name');
    return value ?? AppDefaults.defaultShopName;
  }

  Future<void> setShopName(String name) async {
    await DbHelper.setConfig('shop_name', name);
  }

  Future<bool> getHasPaid() async {
    final value = await DbHelper.getConfig('has_paid');
    return value == 'true';
  }

  Future<void> setHasPaid(bool value) async {
    await DbHelper.setConfig('has_paid', value.toString());
  }

  Future<String> getApiKey() async {
    final value = await DbHelper.getConfig('api_key');
    return value ?? AppDefaults.defaultApiKey;
  }

  Future<void> setApiKey(String key) async {
    await DbHelper.setConfig('api_key', key);
  }

  Future<int> getDbVersion() async {
    final value = await DbHelper.getConfig('db_version');
    return int.tryParse(value ?? '') ?? AppDefaults.defaultDbVersion;
  }
}
