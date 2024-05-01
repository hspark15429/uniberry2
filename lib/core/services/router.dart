import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const Placeholder());
    case '/timetable':
      return MaterialPageRoute(builder: (_) => const Placeholder());
    default:
      return MaterialPageRoute(builder: (_) => const Placeholder());
  }
}
