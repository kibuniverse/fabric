import 'dart:ui';

import 'package:animated_digit/animated_digit.dart';
import 'package:easy_debounce_throttle/throttle/easy_throttle_builder.dart';
import 'package:fabric/model/counter.dart';
import 'package:fabric/utils/snack_bar.dart';
import 'package:fabric/widgets/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef CallbackFunction = void Function(Operation type, [int target]);

// 单个计数器组件
class CounterItemWidget extends StatefulWidget {
  final CounterItem counterItem;
  final String counterKey;
  // 点击回调函数
  final CallbackFunction onTap;

  const CounterItemWidget({
    super.key,
    required this.counterItem,
    required this.counterKey,
    required this.onTap,
  });

  @override
  _CounterItemWidget createState() => _CounterItemWidget();
}

class _CounterItemWidget extends State<CounterItemWidget> {
  // 是否正在记录时间
  bool isRecordingTime = false;
  final TextEditingController _textController = TextEditingController();
  bool isEditTargetNumber = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    // set the counterItem.target to textController value
    _textController.text = widget.counterItem.targetCount.toString();
    // 监听文本变化，确保光标始终在最后
    _textController.addListener(() {
      // 确保光标始终在文本的最后
      _textController.selection =
          TextSelection.collapsed(offset: _textController.text.length);
    });
    super.initState();
  }

  // 挂载后执行生命周期
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onClickInterception(Operation type, [int target = 0]) {
    widget.onTap(type, target);
  }

  void _onClickReset() {
    // 如果当前数字不为0，则提示无需确认
    if (widget.counterItem.currentCount == 0) {
      GlobalSnackBar.show(context: context, message: "当前计数为0, 无需重置");
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('重置计数器'),
          content: const Text('确定要重置当前计数器吗？'),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                // 执行确认操作
                Navigator.of(context).pop(true); // 关闭弹窗并返回true
                _onClickInterception(Operation.reset);
              },
            ),
          ],
        );
      },
    );
  }

  void _onClickAdd() {
    _onClickInterception(Operation.add);
  }

  void _onClickMinus() {
    _onClickInterception(Operation.minus);
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除计数器'),
          content: const Text('确定要删除当前计数器吗？'),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                // 执行确认操作
                Navigator.of(context).pop(true); // 关闭弹窗并返回true
              },
            ),
          ],
        );
      },
    );
  }

  onInput(value) {
    // 如果value为空，设置为0
    if (value.isEmpty) {
      _textController.text = '0';
      return;
    }
    if (value.length > 3) {
      GlobalSnackBar.show(context: context, message: "最多设置3位");
    }
    // 将value的第一位0删除掉
    final formattedValue = value.replaceAll(RegExp(r'^0+'), '');
    // 如果value长度大于3，截取前3位
    _textController.text = formattedValue.length > 3
        ? formattedValue.substring(0, 3)
        : formattedValue;
    // 将formattedValue格式化为int，默认为0
    final formmterValueNumber = int.tryParse(_textController.text) ?? 0;
    _onClickInterception(Operation.updateTarget, formmterValueNumber);
  }

  @override
  Widget build(BuildContext context) {
    return EasyThrottleBuilder(builder: (context, throttle) {
      return Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.counterItem.name,
                    style: const TextStyle(
                        // 设置 color 为 #00000066
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showConfirmDialog(context);
                    },
                    child: SvgPicture.asset(
                      width: 21,
                      height: 21,
                      "assets/images/svg/delete.svg",
                      semanticsLabel: "删除",
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 60),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => throttle(() => _onClickMinus()),
                    child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          // #E6E6FA
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10000),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(26),
                          child: SvgPicture.asset(
                            "assets/images/svg/minus.svg",
                            semanticsLabel: "计数器减少",
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: AnimatedDigitWidget(
                        loop: false,
                        value: widget.counterItem.currentCount,
                        textStyle: const TextStyle(
                            fontSize: 48,
                            // 设置颜色为 #E6E6FA
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => throttle(() => _onClickAdd()),
                    child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          // #E6E6FA
                          color: const Color(0xFFE6E6FA),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(26),
                          child: SvgPicture.asset(
                            "assets/images/svg/plus.svg",
                            semanticsLabel: "计数器增加",
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: TimerWidget(
                  isActive: isRecordingTime,
                  initCounter: widget.counterItem.timing),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRecordingTime = !isRecordingTime;
                            });
                          },
                          child: SvgPicture.asset(
                            width: 40,
                            height: 40,
                            "assets/images/svg/${isRecordingTime ? 'recording_time' : "stop_record_time"}.svg",
                            semanticsLabel: "计时",
                          ),
                        ),
                        GestureDetector(
                            onTap: _onClickReset,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(
                                width: 40,
                                height: 40,
                                "assets/images/svg/reset_counter.svg",
                                semanticsLabel: "重置",
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: SvgPicture.asset(
                            'assets/images/svg/target.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const Text(
                          '设置目标：',
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {},
                          onDoubleTap: () {
                            setState(() {
                              isEditTargetNumber = !isEditTargetNumber;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: !isEditTargetNumber
                                ? IntrinsicWidth(
                                    stepWidth: 1,
                                    child: TextField(
                                        cursorHeight: 30,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        style: const TextStyle(
                                          color: Color(0xffA889C8),
                                          fontSize: 36,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        controller: _textController,
                                        keyboardType: TextInputType.number,
                                        onChanged: onInput))
                                : Text(
                                    widget.counterItem.targetCount.toString(),
                                    style: const TextStyle(
                                        color: Color(0xffA889C8),
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500),
                                  ),
                          ),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      );
    });
  }
}
