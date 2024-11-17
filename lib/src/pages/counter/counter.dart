import "package:fabric/src/libs/storage/counter.dart";
import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import "package:get_storage/get_storage.dart";
import "package:haptic_feedback/haptic_feedback.dart";

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

  final box = GetStorage();
  SnackBar? snackBar;

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
  }

  showSnackBar(String text) {
    if (snackBar != null) {
      // 暂停上一个 snackBar 的显示
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.purple[900]),
      ),
      behavior: SnackBarBehavior.fixed,
      elevation: 0, // 设置阴影高度
      backgroundColor: const Color(0xFFE6E6FA),
      duration: Durations.extralong4,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar!);
  }

  void _handleVibrationTap(bool v, BuildContext context) async {
    // 创建SnackBar
    final snackText = v ? '震动反馈已开启' : "震动反馈已关闭";
    showSnackBar(snackText);

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

  void _handleKeepScreenTap(bool v, BuildContext context) async {
    // 创建SnackBar
    final snackText = v ? '屏幕长亮已开启' : "屏幕长亮已关闭";
    showSnackBar(snackText);

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
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
                    _handleKeepScreenTap(!enableKeepScreen, context);
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
      ],
    ));
  }
}
