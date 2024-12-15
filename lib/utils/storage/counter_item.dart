import 'dart:convert';

import 'package:fabric/constants/constants.dart';
import 'package:fabric/model/counter.dart';
import 'package:fabric/utils/storage/counter.dart';
import 'package:get_storage/get_storage.dart';

/// 单个计数器
class CounterItemStorage {
  static final _box = GetStorage("counter");

  CounterItem loadCounterItemModel(String key) {
    final String? json = _box.read(key);
    if (json != null) {
      final Map<String, dynamic> map = jsonDecode(json);
      return CounterItem.fromJson(map);
    }
    final number = CounterStorage().getCurrentCounterNumber();
    return genDefaultCounterItem(number);
  }

  /// 计数器加一
  CounterItem addCounterItemModel(String key) {
    final counterItem = loadCounterItemModel(key);
    counterItem.currentCount++;
    _box.write(key, jsonEncode(counterItem.toJson()));
    return counterItem;
  }

  /// 计数器减一
  void minusCounterItemModel(String key) {
    final counterItem = loadCounterItemModel(key);
    counterItem.currentCount--;
    _box.write(key, jsonEncode(counterItem.toJson()));
  }

  /// 计数器重置
  void resetCounterItemModel(String key) {
    final counterItem = loadCounterItemModel(key);
    counterItem.currentCount = 0;
    _box.write(key, jsonEncode(counterItem.toJson()));
  }

  /// 计数器删除
  void deleteCounterItemModel(String key) {
    _box.remove(key);
  }

  /// 更新时间戳
  void updateTimeStamp(String key, int timing) {
    final counterItem = loadCounterItemModel(key);
    counterItem.timing = timing;
    _box.write(key, jsonEncode(counterItem.toJson()));
  }

  /// 更新目标数
  void updateTargetCount(String key, int targetCount) {
    final counterItem = loadCounterItemModel(key);
    counterItem.targetCount = targetCount;
    _box.write(key, jsonEncode(counterItem.toJson()));
  }

  /// 添加操作历史
  void addOperateItem(String key, Map<String, dynamic> operateItem) {
    final counterItem = loadCounterItemModel(key);
    counterItem.operateHistory.add(operateItem);
    _box.write(key, jsonEncode(counterItem.toJson()));
  }
}
