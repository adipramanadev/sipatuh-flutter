import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerService {
  CacheManager _cacheManager = DefaultCacheManager();

  CacheManagerService() {
    _cacheManager = DefaultCacheManager();
  }

  Future<void> saveVariable(String key, dynamic value) async {
    String stringValue = jsonEncode(value);
    await _cacheManager.putFile(
        key, Uint8List.fromList(utf8.encode(stringValue)));
  }

  Future<String?> getVariable(String key) async {
    File file = await _cacheManager.getSingleFile(key);
    // ignore: unnecessary_null_comparison
    if (file != null) {
      List<int> fileBytes = await file.readAsBytes();
      String cachedValue = utf8.decode(fileBytes);
      return cachedValue;
    } else {
      return null;
    }
  }

  Future<void> removeVariable(String key) async {
    await _cacheManager.removeFile(key);
  }
}
