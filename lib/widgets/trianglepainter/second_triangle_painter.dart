import 'package:flutter/material.dart';

/// 绘制三角形

class SecondTrianglePainter extends CustomPainter {
  Color color; //填充颜色
  Paint _paint; //画笔
  Path _path; //绘制路径
  double angle; //角度

  SecondTrianglePainter(this.color) {
    _paint = Paint()
      ..strokeWidth = 1.0 //线宽
      ..color = color
      ..isAntiAlias = true;
    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final baseX = size.width * 1;
    final baseY = size.height * 1;
    //起点
    _path.moveTo(0.85 * baseX, -30);
    _path.lineTo(0.47 * baseX, 1 * baseY);
    _path.lineTo(baseX, 1 * baseY);
    _path.lineTo(baseX, -30);
    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
