import 'package:flutter/material.dart';
import 'package:isa/data_structure/graph.dart';
import 'package:isa/heuristics.dart';
import 'package:isa/map/map.dart';
import 'package:isa/state.dart' as stat;

import 'aStar.dart';

void main() {
  RoadMap roadMap = RoadMap();

  AdjacencyList map = roadMap.getGraph();
  Edge empty = Edge(
    source: roadMap.college!,
    destination: roadMap.college!,
    distance: 0,
    busSpeed: 0,
    taxiSpeed: 0,
    busStationName: 'college',
    type: Transportation.none,
  );
  AdjacencyList graph = AdjacencyList(connections: {});
  stat.State state = stat.State(
      currentHealth:100,
      currentMoney: 10000,
      consumedTime: 0,
      path: [],
      graph: graph,
      currentVertex: roadMap.college!,
      map: map,
      previousEdge: empty);
  // state.getNextStates();
  Heuristics heuristics = Heuristics();
  AStar aStar = AStar(state: state, heuristics: heuristics);
  List<Vertex> start = [];
  start.add(state.currentVertex);
  aStar.algorithm(start, roadMap.home!).printState();
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
