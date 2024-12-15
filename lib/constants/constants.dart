import 'package:fabric/model/counter.dart';

genDefaultCounterItem(int number) {
  return CounterItem(
      key: 'counter_$number',
      name: '默认计数器$number',
      targetCount: 0,
      currentCount: 0,
      timing: 0,
      isDelete: false,
      operateHistory: []);
}

/// 最大计数器数量
const maxCounterNumber = 999;

/// 最小计数器数量
const minCounterNumber = 0;

/// 需要被记录的操作类型
const needToBeRecordOperateType = [
  Operation.add,
  Operation.minus,
  Operation.reset
];
