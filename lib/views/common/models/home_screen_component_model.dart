import 'package:flutter/material.dart';

class HomeScreenComponentModel {
  final IconData icon, activeIcon;
  final Widget screen;
  final String title;

  const HomeScreenComponentModel({
    required this.icon,
    required this.activeIcon,
    required this.screen,
    required this.title,
  });
}