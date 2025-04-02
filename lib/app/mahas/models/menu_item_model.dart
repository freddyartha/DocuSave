import 'package:flutter/material.dart';

class MenuItemModel {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final String? image;
  final GestureTapCallback? onTab;
  final GlobalKey? globalKey;
  final Color? color;

  MenuItemModel({
    @required this.title,
    this.subtitle,
    this.icon,
    this.image,
    this.onTab,
    this.globalKey,
    this.color,
  });
}
