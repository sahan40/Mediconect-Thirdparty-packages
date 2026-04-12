import 'package:hive/hive.dart';

class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  Box<String>? _box;

  Future<Box<String>> ensureInitialized() async {
    if (_box?.isOpen == true) return _box!;
    _box = await Hive.openBox<String>('app_kv');
    return _box!;
  }

  Future<void> putValue({required String key, required String value}) async {
    final box = await ensureInitialized();
    await box.put(key, value);
  }

  Future<String?> getValue(String key) async {
    final box = await ensureInitialized();
    return box.get(key);
  }

  Future<void> clearValue(String key) async {
    final box = await ensureInitialized();
    await box.delete(key);
  }
}
