/** 计时器组件 */
import 'package:animated_digit/animated_digit.dart';
import 'package:fabric/utils/time.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  final VoidCallback? onTick; // 每秒回调
  final bool isActive; // 是否激活计时器
  final int initCounter; // 初始计数器值

  const TimerWidget(
      {Key? key, this.onTick, this.isActive = false, this.initCounter = 0})
      : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _count = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 初始化计数器值
    _count = widget.initCounter;
    if (widget.isActive) {
      // _startCounter();
    }
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isActiveChanges = oldWidget.isActive != widget.isActive;
    if (isActiveChanges) {
      if (widget.isActive) {
        _startCounter();
      } else {
        _pauseCounter();
      }
    }
  }

  void _startCounter() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _count++;
        });
        if (widget.onTick != null) {
          widget.onTick!();
        }
      }
    });
  }

  void _pauseCounter() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _pauseCounter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 将s单位的时间转换为时分和秒
    final [hours, minutes, seconds] = convertSecondsToHmsString(_count);
    final text = "$hours:$minutes:$seconds";
    return Text(
      text,
      style: TextStyle(fontSize: 18, color: Colors.black45),
    );
  }
}
