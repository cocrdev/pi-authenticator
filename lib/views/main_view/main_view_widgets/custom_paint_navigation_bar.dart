/*
 * privacyIDEA Authenticator
 *
 * Author: Frank Merkel <frank.merkel@netknights.it>
 *
 * Copyright (c) 2024-2025 NetKnights GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:math';

import 'package:flutter/material.dart';

class CustomPaintNavigationBar extends CustomPainter {
  BuildContext buildContext;

  CustomPaintNavigationBar({required this.buildContext});

// It is basicly grid of 1x1 from 0,0 top left to 1,1 bottom right with height and width of [size]
// We use a maximum of px for radius to make sure the floating action button has enough space but not too much
// point 1: 0, 0.3
// point 2: 0.5 (-radiusPx-15px), 0  (cp: 0.2, 0)              // controlpoint for the curve
// point 3: 0.5 (-radiusPx), 0.2     (cp: 0.5 (-radiusPx), 0)
// point 4: 0.5 (+radiusPx), 0.2
// point 5: 0.5 (+radiusPx+15px), 0  (cp: 0.5 (+radiusPx), 0)
// point 6: 1, 0.3                   (cp: 0.8, 0)
// point 7: 1, 1
// point 8: 0, 1
// point 1: 0, 0.3 (close)

  // paints the curves of the appbar
  @override
  void paint(Canvas canvas, Size size) {
    final Color appBarColor =
        Theme.of(buildContext).navigationBarTheme.backgroundColor ?? Theme.of(buildContext).appBarTheme.backgroundColor ?? Theme.of(buildContext).primaryColor;
    final Color shadowColor =
        Theme.of(buildContext).navigationBarTheme.shadowColor ?? Theme.of(buildContext).appBarTheme.shadowColor ?? Theme.of(buildContext).shadowColor;
    final elevation = Theme.of(buildContext).navigationBarTheme.elevation ?? 3;
    final double radiusPx = min(40, size.height * 0.8);
    Paint paint = Paint()
      ..color = appBarColor
      ..style = PaintingStyle.fill;
    Path path = Path()
      ..moveTo(size.width * 0.0, size.height * 0.3) // point 1
      ..quadraticBezierTo(size.width * 0.20, size.height * 0.0, size.width * 0.5 - radiusPx - 15, size.height * 0.0) // point 2
      ..quadraticBezierTo(size.width * 0.5 - radiusPx, size.height * 0.0, size.width * 0.5 - radiusPx, size.height * 0.2) // point 3
      ..arcToPoint(Offset(size.width * 0.5 + radiusPx, size.height * 0.2), radius: Radius.circular(radiusPx), clockwise: false) // point 4
      ..quadraticBezierTo(size.width * 0.5 + radiusPx, size.height * 0.0, size.width * 0.5 + radiusPx + 15, size.height * 0.0) // point 5
      ..quadraticBezierTo(size.width * 0.80, 0, size.width, size.height * 0.3) // point 6
      ..lineTo(size.width * 1.0, size.height * 1.0) // point 7
      ..lineTo(size.width * 0.0, size.height * 1.0) // point 8
      ..close(); // point 1

    canvas.translate(0, -elevation);
    canvas.drawShadow(path, shadowColor, elevation, true);
    canvas.translate(0, elevation);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
