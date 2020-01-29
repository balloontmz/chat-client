import 'package:chat/widgets/trianglepainter/first_triangle_painter.dart';
import 'package:chat/widgets/trianglepainter/four_triangle_painter.dart';
import 'package:chat/widgets/trianglepainter/second_triangle_painter.dart';
import 'package:chat/widgets/trianglepainter/third_triangle_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget createHeaderImage(Widget Function() buildContent) {
  return new CustomPaint(
    painter: new FirstTrianglePainter(Color(0xff4357C8)),
    child: new RepaintBoundary(
      child: new CustomPaint(
        painter: SecondTrianglePainter(Color(0xff34489E)),
        child: new RepaintBoundary(
          child: new CustomPaint(
            painter: ThirdTrianglePainter(Color(0xff108FF0)),
            child: new RepaintBoundary(
              child: new CustomPaint(
                painter: FourTrianglePainter(Colors.white),
                child: buildContent(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
