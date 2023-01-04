import 'package:flutter/material.dart';
import 'package:isa/data_structure/graph.dart';
import 'package:isa/heuristics.dart';
import 'package:isa/map/map.dart';
import 'package:isa/state.dart' as stat;

void main() {
  RoadMap roadMap = RoadMap();
  AdjacencyList map = roadMap.getGraph();
  AdjacencyList graph = AdjacencyList(connections: {});
  stat.State state = stat.State(currentHealth: 100, currentMoney: 1000, consumedTime: 0, path: [], graph: graph, currentVertex: roadMap.college!,map: map);
 state.getNextStates();
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
