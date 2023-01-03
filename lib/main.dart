import 'package:flutter/material.dart';
import 'package:isa/heuristics.dart';
import 'package:isa/map/map.dart';

void main() {
  RoadMap roadMap = RoadMap();
  // roadMap.getGraph();
  heuristics a = heuristics();
  a.mainfun();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ISA',
      home: Scaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
