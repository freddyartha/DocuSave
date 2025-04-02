import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ReusableStatics {
  static double appBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top + kToolbarHeight;

  static String idGenerator() {
    const uuid = Uuid();
    var r = uuid.v8();
    return r;
  }
}
