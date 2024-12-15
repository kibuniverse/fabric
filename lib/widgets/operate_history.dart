import 'package:fabric/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:fabric/utils/operate_history.dart";

class OperateHistory extends StatelessWidget {
  final List<Map<String, dynamic>> operateHistory;
  const OperateHistory({super.key, required this.operateHistory});
  @override
  Widget build(BuildContext context) {
    var lastItem = operateHistory.last;
    return Expanded(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/svg/vector.svg",
              semanticsLabel: "操作记录",
              width: 14,
              height: 14,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text("操作记录",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black45)),
            )
          ],
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // reverse 倒序遍历
                    // 倒序遍历
                    for (var item in operateHistory.reversed)
                      Container(
                        padding: const EdgeInsets.only(left: 37, right: 37),
                        child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.black12, width: 1.0)),
                            ),
                            padding: const EdgeInsets.only(top: 7, bottom: 7),
                            child: DefaultTextStyle(
                                style: TextStyle(
                                  color: lastItem == item
                                      //#A889C8
                                      ? const Color(0xFFA889C8)
                                      : Colors.black45,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        convertTimestampToTimeString(
                                            item['timestamp']),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                        )),
                                    // 使用 操作类型 映射表operationTextMap
                                    Text(getOperateHistoryText(item['type']),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                        )),
                                    Text(
                                      "${item['counter_number'].toString()}行",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                      ),
                                    )
                                  ],
                                ))),
                      )
                  ],
                ),
              )),
        )
      ],
    ));
  }
}
