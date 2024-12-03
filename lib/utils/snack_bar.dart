import 'package:flutter/material.dart';

class GlobalSnackBar {
  // 显示SnackBar的静态方法
  static void show({
    required BuildContext context,
    required String message,
  }) {
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);

    // 移除当前的SnackBar
    scaffoldMessenger.removeCurrentSnackBar();

    // 创建新的SnackBar
    final SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.purple[900]),
      ),
      behavior: SnackBarBehavior.fixed,
      elevation: 0, // 设置阴影高度
      backgroundColor: const Color(0xFFE6E6FA),
      duration: Durations.extralong4,
    );

    // 显示新的SnackBar
    scaffoldMessenger.showSnackBar(snackBar);
  }
}
