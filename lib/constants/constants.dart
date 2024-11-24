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
