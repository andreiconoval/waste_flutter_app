import 'package:flutter/material.dart';
import 'package:waste_on_map_app/Routes/MapRoute.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MapRoute(),
  ));
}
