import "package:easy_debounce_throttle/easy_debounce_throttle.dart";
import "package:fabric/constants/constants.dart";
import "package:fabric/model/counter.dart";
import "package:fabric/utils/snack_bar.dart";
import "package:fabric/utils/storage/counter.dart";
import "package:fabric/utils/storage/counter_item.dart";
import "package:fabric/widgets/counter_item.dart";
import "package:fabric/widgets/operate_history.dart";
import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import "package:get_storage/get_storage.dart";
import "package:haptic_feedback/haptic_feedback.dart";
import "package:wakelock_plus/wakelock_plus.dart";

class Counter extends StatefulWidget {
  const Counter({super.key});
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  /// 是否开启震动
  bool enableVibration = true;

  /// 是否开启屏幕常亮
  bool enableKeepScreen = true;

  bool _canVibrate = false;

  List<CounterItem> counterItems = [];

  final box = GetStorage();

  _checkVibrationCapability() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate == false) {
      // 设备不支持震动反馈
      // 上报到 sentry
      return;
    }
    setState(() {
      _canVibrate = canVibrate;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkVibrationCapability();
    final counterStorage = CounterStorage().loadCounterModel();
    enableVibration = counterStorage.enableVibration;
    enableKeepScreen = counterStorage.enableKeepScreenOn;
    final counterKeys = counterStorage.counterKeys;
    // 特殊逻辑，app 冷启 时 WakeLockPlus 需要手动启用
    if (enableKeepScreen) {
      WakelockPlus.enable();
    }

    counterItems = counterKeys.map((key) {
      return CounterItemStorage().loadCounterItemModel(key);
    }).toList();
  }

  void _handleVibrationTap(bool v, BuildContext context) async {
    // 创建SnackBar
    final snackText = v ? '震动反馈已开启' : "震动反馈已关闭";
    GlobalSnackBar.show(context: context, message: snackText);

    // 震动反馈
    // 默认使用 HapticsType.soft 震动
    if (v == true) {
      _performVibration(HapticsType.soft);
    }
    // 显示SnackBar
    CounterStorage().updateVibration(v);
    setState(() {
      enableVibration = v;
    });
  }

  void _handleKeepScreenTap(bool v) async {
    // 创建SnackBar
    final snackText = v ? '屏幕长亮已开启' : "屏幕长亮已关闭";
    if (v) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
    GlobalSnackBar.show(context: context, message: snackText);

    CounterStorage().updateKeepScreen(v);
    setState(() {
      enableKeepScreen = v;
    });
  }

  void _performVibration(HapticsType type) {
    if (!_canVibrate) {
      return;
    }
    Haptics.vibrate(type);
  }

  /// 处理点击计时器+事件
  void _addCounterItem(String key) {
    if (enableVibration) {
      _performVibration(HapticsType.soft);
    }
    final newCounterItem = CounterItemStorage().addCounterItemModel(key);
    if (newCounterItem.targetCount == newCounterItem.currentCount) {
      
    }
  }

  /// 处理点击计数器-事件
  void _minusCounterItem(String key) {
    final counterItem = CounterItemStorage().loadCounterItemModel(key);
    if (counterItem.currentCount == minCounterNumber) {
      GlobalSnackBar.show(context: context, message: "计数器已到最小值");
      return;
    }
    if (enableVibration) {
      _performVibration(HapticsType.soft);
    }
    CounterItemStorage().minusCounterItemModel(key);
  }

  /// 处理重置
  void _resetCounterItem(String key) {
    CounterItemStorage().resetCounterItemModel(key);
  }

  void _handleAddHistory(
      String key, Operation type, CounterItem newCounterItem) {
    final operateItem = {
      'type': type.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'counter_number': newCounterItem.currentCount,
    };
    CounterItemStorage().addOperateItem(key, operateItem);
  }

  void _updateTargetCount(String key, int count) {
    CounterItemStorage().updateTargetCount(key, count);
  }

  /// 计数器点击行为，统一处理中心
  /// [Operation] 为操作类型，包括增加，减少，重置
  void _counterItemClick(String key, Operation type, [int target = 0]) {
    if (type == Operation.add) {
      _addCounterItem(key);
    }
    if (type == Operation.minus) {
      _minusCounterItem(key);
    }
    if (type == Operation.reset) {
      _resetCounterItem(key);
    }

    if (type == Operation.updateTarget) {
      _updateTargetCount(key, target);
    }

    if (needToBeRecordOperateType.contains(type)) {
      _handleAddHistory(
          key, type, CounterItemStorage().loadCounterItemModel(key));
    }

    final newCounterItems = counterItems.map((counterItem) {
      if (counterItem.key == key) {
        return CounterItemStorage().loadCounterItemModel(key);
      }
      return counterItem;
    }).toList();
    setState(() {
      counterItems = newCounterItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 22.0, left: 22, right: 22, bottom: 6),
          child: Row(children: [
            const Expanded(
              child: Text(
                "行计数器",
                style: TextStyle(
                    // 设置 color 为 #333333
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      _handleVibrationTap(!enableVibration, context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: SvgPicture.asset(
                        "assets/images/svg/${enableVibration ? "enable" : "disable"}_vibration.svg",
                        semanticsLabel: "震动",
                      ),
                    )),
                GestureDetector(
                  onTap: () {
                    _handleKeepScreenTap(!enableKeepScreen);
                  },
                  child: SvgPicture.asset(
                    "assets/images/svg/keep_screen_${enableKeepScreen ? "on" : "off"}.svg",
                    semanticsLabel: "屏幕长亮",
                  ),
                )
              ],
            )
          ]),
        ),
        Expanded(
            child: DefaultTabController(
          length: counterItems.length,
          child: Column(children: [
            TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelColor: const Color(0xFFA889C8),
              unselectedLabelColor: const Color(0xCC333333),
              indicatorColor: const Color(0xFFA889C8),
              indicatorPadding: const EdgeInsets.only(left: 10.0, right: 10),
              tabs: counterItems
                  .map((counterItem) => Tab(
                        child: Text(
                          counterItem.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ))
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: counterItems.map((counterItem) {
                  return Column(children: [
                    CounterItemWidget(
                      counterItem: counterItem,
                      counterKey: counterItem.key,
                      onTap: (Operation type, [int target = 0]) {
                        _counterItemClick(counterItem.key, type, target);
                      },
                    ),
                    OperateHistory(operateHistory: counterItem.operateHistory),
                  ]);
                }).toList(),
              ),
            )
          ]),
        ))
      ],
    ));
  }
}
