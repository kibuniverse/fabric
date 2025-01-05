import 'package:flutter/material.dart';

class CustomUnderlineTabIndicator extends UnderlineTabIndicator {
  final double? customWidth; // 自定义宽度
  final double? verticalPadding; // 垂直间距
  final BorderRadius? borderRadius; // 圆角

  CustomUnderlineTabIndicator({
    BorderSide borderSide = const BorderSide(width: 2.0, color: Colors.white),
    EdgeInsetsGeometry insets = EdgeInsets.zero,
    this.customWidth,
    this.verticalPadding,
    this.borderRadius,
  }) : super(borderSide: borderSide, insets: insets);

  @override
  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    if (customWidth != null) {
      double cw = (indicator.left + indicator.right) / 2;
      return Rect.fromLTWH(
        cw - customWidth! / 2,
        indicator.bottom - borderSide.width - (verticalPadding ?? 0),
        customWidth!,
        borderSide.width,
      );
    } else {
      return Rect.fromLTWH(
        indicator.left,
        indicator.bottom - borderSide.width - (verticalPadding ?? 0),
        indicator.width,
        borderSide.width,
      );
    }
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = _indicatorRectFor(
      offset & configuration.size!,
      configuration.textDirection!,
    );

    final RRect rRect = borderRadius != null
        ? RRect.fromRectAndCorners(
            rect,
            topLeft: borderRadius!.topLeft,
            topRight: borderRadius!.topRight,
            bottomLeft: borderRadius!.bottomLeft,
            bottomRight: borderRadius!.bottomRight,
          )
        : RRect.fromRectXY(rect, 0, 0);

    final Paint paint = borderSide.toPaint()
      ..style = PaintingStyle.fill
      ..strokeWidth = borderSide.width;

    canvas.drawRRect(rRect, paint);
  }
}
