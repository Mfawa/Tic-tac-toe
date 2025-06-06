import 'package:flutter/material.dart';

Decoration redDecoration = BoxDecoration(
  color: Colors.red,
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(150),
    bottomRight: Radius.circular(150),
  ),
);

Decoration blueDecoration = BoxDecoration(
  color: Colors.blue,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(150),
    topRight: Radius.circular(150),
  ),
);
