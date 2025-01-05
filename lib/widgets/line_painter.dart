import 'package:flutter/material.dart';

class FullWidthLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0x1A000000) // 设置颜色为#0000001A
      ..strokeWidth = 2.0 // 设置线宽
      ..style = PaintingStyle.stroke; // 设置为描边样式

    // 绘制一条宽度与屏幕一致的线
    canvas.drawLine(
      Offset(0, size.height / 2), // 起始点
      Offset(size.width, size.height / 2), // 结束点
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
