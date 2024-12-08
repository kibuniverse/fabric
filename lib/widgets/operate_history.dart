import 'package:flutter/material.dart';

class OperateHistory extends StatelessWidget {
  final List<Map<String, dynamic>> operateHistory;
  const OperateHistory({super.key, required this.operateHistory});
  @override
  Widget build(BuildContext context) {
    return Text("操作记录");
  }
}
