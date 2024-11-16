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
      return CounterModel.fromJson(map);
    }
    return CounterModel(
        enableVibration: true, enableKeepScreenOn: true, counterKeys: []);
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

  saveCounterModel(CounterModel model) {
    final String json = jsonEncode(model.toJson());
    _box.write(CounterStorageKeys.globalConfigNew.toString(), json);
  }
}
