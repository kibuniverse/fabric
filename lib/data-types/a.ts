interface CounterModel {
  /// 是否开启震动 默认为true
  enableVibration: boolean;

  // 是否开启屏幕常亮 默认为true
  enableKeepScreenOn: boolean;

  // 计数器
  counters: Array<Counter>;
}

interface Counter {
  // 目标针数
  targetCount: number;
  // 目前的针数
  currentCount: number;
  // 计时的时间 时间戳类型 ms
  timing: number;
  // 是否被删除
  isDelete: boolean;
  operateHistory: Array<{
    // 时间戳 ms
    time: number;
    // 操作的名称
    name: string;
    // 操作的明细
    label: string;
  }>;
}
