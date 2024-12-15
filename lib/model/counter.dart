class CounterModel {
  /// 是否开启震动，默认为true
  bool enableVibration;

  /// 是否开启屏幕常亮，默认为true
  bool enableKeepScreenOn;

  /// 计数器
  List<String> counterKeys;

  CounterModel({
    required this.enableVibration,
    required this.enableKeepScreenOn,
    required this.counterKeys,
  });

  // 从JSON对象创建CounterModel对象的工厂构造函数
  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      enableVibration: json['enableVibration'] as bool,
      enableKeepScreenOn: json['enableKeepScreenOn'] as bool,
      counterKeys: List<String>.from(json['counterKeys']),
    );
  }

  // 将CounterModel对象转换为JSON对象
  Map<String, dynamic> toJson() {
    return {
      'enableVibration': enableVibration,
      'enableKeepScreenOn': enableKeepScreenOn,
      'counterKeys': counterKeys,
    };
  }
}

class CounterItem {
  /// 唯一标识 用于本地存储
  String key;

  /// 名称
  String name;

  /// 目标针数
  int targetCount;

  /// 目前的针数
  int currentCount;

  /// 计时的时间 时间戳类型 ms
  int timing;

  /// 是否被删除
  bool isDelete;

  /// 操作历史
  List<Map<String, dynamic>> operateHistory;

  CounterItem({
    required this.key,
    required this.name,
    required this.targetCount,
    required this.currentCount,
    required this.timing,
    required this.isDelete,
    required this.operateHistory,
  });

  // 从JSON对象创建Counter对象的工厂构造函数
  factory CounterItem.fromJson(Map<String, dynamic> json) {
    return CounterItem(
      key: json['key'] as String,
      name: json['name'] as String,
      targetCount: json['targetCount'] as int,
      currentCount: json['currentCount'] as int,
      timing: json['timing'] as int,
      isDelete: json['isDelete'] as bool,
      operateHistory: List<Map<String, dynamic>>.from(
        json['operateHistory'].map((x) => Map<String, dynamic>.from(x)),
      ),
    );
  }

  // 将Counter对象转换为JSON对象
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'timing': timing,
      'isDelete': isDelete,
      'operateHistory': operateHistory,
    };
  }
}

enum Operation {
  add,
  minus,
  reset,
  delete,
  updateTarget,
  beginRecordTime,
  endRecordTime,
}
