import 'dart:convert';

import 'package:animated_digit/animated_digit.dart';
import 'package:fabric/model/counter.dart';
import 'package:fabric/widgets/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef CallbackFunction = void Function(Operation type);

// 单个计数器组件
class CounterItemWidget extends StatefulWidget {
  final CounterItem counterItem;
  final String counterKey;
  // 点击回调函数
  final CallbackFunction onTap;

  CounterItemWidget({
    Key? key,
    required this.counterItem,
    required this.counterKey,
    required this.onTap,
  }) : super(key: key);

  @override
  _CounterItemWidget createState() => _CounterItemWidget();
}

class _CounterItemWidget extends State<CounterItemWidget> {
  // 是否正在记录时间
  bool isRecordingTime = false;

  void _onClickInterception(Operation type) {
    widget.onTap(type);
  }

  void _onClickReset() {
    _onClickInterception(Operation.reset);
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

  @override
  Widget build(BuildContext context) {
    print(
        "CounterItemWidget build ${jsonEncode(widget.counterItem)} $widget.counterKey");
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 17,
                  bottom: 22,
                ),
                child: Text(
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold),
                    "已织了..."),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _onClickMinus,
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        // #E6E6FA
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10000),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(26),
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
                      textStyle: TextStyle(
                          fontSize: 48,
                          // 设置颜色为 #E6E6FA
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _onClickAdd,
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        // #E6E6FA
                        color: Color(0xFFE6E6FA),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(26),
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
            padding: EdgeInsets.only(top: 22),
            child: TimerWidget(
                isActive: isRecordingTime,
                initCounter: widget.counterItem.timing),
          ),
          Padding(
              padding: EdgeInsets.only(top: 44),
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
                            padding: EdgeInsets.only(left: 20),
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isRecordingTime = !isRecordingTime;
                          });
                        },
                        child: SvgPicture.asset(
                          width: 40,
                          height: 40,
                          "assets/images/svg/target.svg",
                          semanticsLabel: "目标针数",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(left: 26),
                          child: Text(
                            widget.counterItem.targetCount.toString(),
                            style: TextStyle(
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
  }
}
