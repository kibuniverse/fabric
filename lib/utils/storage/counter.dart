import "dart:convert";

import "package:fabric/model/counter.dart";
import "package:get_storage/get_storage.dart";

enum CounterStorageKeys { globalConfigNew }

class CounterStorage {
  static final _box = GetStorage("counter");

  CounterModel loadCounterModel() {
    final String? json =
        _box.read(CounterStorageKeys.globalConfigNew.toString());

    if (json != null) {
      final Map<String, dynamic> map = jsonDecode(json);
      final r = CounterModel.fromJson(map);
      if (r.counterKeys.isEmpty) {
        r.counterKeys.add("counter_1");
      }
      return r;
    }

    return CounterModel(
        enableVibration: true,
        enableKeepScreenOn: true,
        counterKeys: ["counter_1"]);
  }

  /// 获取当前计数器数量
  int getCurrentCounterNumber() {
    final model = loadCounterModel();
    return model.counterKeys.length;
  }

  setGlobalConfig(String config) =>
      _box.write(CounterStorageKeys.globalConfigNew.toString(), config);

  /// 切换是否开启震动
  updateVibration(bool enable) {
    final model = loadCounterModel();
    model.enableVibration = enable;
    saveCounterModel(model);
  }

  /// 切换是否开启屏幕常亮
  updateKeepScreen(bool enable) {
    final model = loadCounterModel();
    model.enableKeepScreenOn = enable;
    saveCounterModel(model);
  }

  /// 新增一个计数器
  addCounterItemModel() {
    final number = getCurrentCounterNumber();
    final model = loadCounterModel();
    model.counterKeys.add("counter_$number");
    saveCounterModel(model);
  }

  saveCounterModel(CounterModel model) {
    final String json = jsonEncode(model.toJson());
    _box.write(CounterStorageKeys.globalConfigNew.toString(), json);
  }
}
