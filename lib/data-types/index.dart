class CounterModel {
  /// 是否开启震动 默认为true
  bool enableVibration = true; //
  /// 是否开启屏幕常亮 默认为true
  bool enableKeepScreenOn = true;

  /// 计数器
  List<Counter> counters;

  CounterModel(
      {this.enableVibration = true,
      this.enableKeepScreenOn = true,
      this.counters = const []});
}

/// 计数器类，用于跟踪目标针数、当前针数、计时时间、是否被删除以及操作历史记录。
class Counter {
  /// 目标针数。
  int targetCount;

  /// 当前的针数。
  int currentCount;

  /// 计时的时间，时间戳类型，毫秒。
  int timing;

  /// 是否被删除。
  bool isDelete;

  /// 操作历史记录。
  List<OperateHistory> operateHistory;

  Counter({
    this.targetCount = 0,
    this.currentCount = 0,
    this.timing = 0,
    this.isDelete = false,
    this.operateHistory = const [],
  });
}

/// 操作历史记录类，用于记录时间戳、操作名称和操作明细。
class OperateHistory {
  /// 时间戳，毫秒。
  int time;

  /// 操作的名称。
  String name;

  /// 操作的明细。
  String label;

  /// OperateHistory 类的构造函数。
  /// OperateHistory 类的构造函数。
  OperateHistory({
    this.time = 0,
    this.name = '',
    this.label = '',
  });
}
