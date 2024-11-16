import "package:fabric/src/libs/storage/counter.dart";
import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import "package:get_storage/get_storage.dart";

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

  final box = GetStorage();
  SnackBar? snackBar;
  @override
  void initState() {
    super.initState();
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

  void _handleVibrationTap(bool v, BuildContext context) {
    // 创建SnackBar
    final snackText = v ? '震动反馈已开启' : "震动反馈已关闭";
    showSnackBar(snackText);
    // 显示SnackBar
    CounterStorage().updateVibration(v);
    setState(() {
      enableVibration = v;
    });
  }

  void _handleKeepScreenTap(bool v, BuildContext context) {
    // 创建SnackBar
    final snackText = v ? '屏幕长亮已开启' : "屏幕长亮已关闭";
    showSnackBar(snackText);

    CounterStorage().updateKeepScreen(v);
    setState(() {
      enableKeepScreen = v;
    });
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
                    color: Colors.black,
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
