import 'dart:core';

import 'package:isa/data_structure/collection.dart';
import 'package:isa/data_structure/graph.dart';
import 'package:isa/heuristics.dart';
import 'package:isa/state.dart';

class AStar {
  State state;
  Heuristics heuristics;

  AStar({required this.state, required this.heuristics});

  double pathWeight(List<Vertex> $path) {
    state = state.copyWith();
    double g_cost = 0;
    double weight = 0;
    double f_cost = 0;
    double w_cost = 0;

    List<Edge> availableMove = state.checkMoves();
    for (Edge edge in availableMove) {
      if (edge.type == Transportation.taxi) {
        heuristics = Heuristics(state: state, type: Transportation.taxi);
        weight = heuristics.mainFun();
        w_cost = weight;

        for (Vertex vertex in $path) {
          g_cost += state.getTimeConsume(edge, edge.type);
        }
      } else if (edge.type == Transportation.bus) {
        heuristics = Heuristics(state: state, type: Transportation.bus);
        weight = heuristics.mainFun();
        w_cost = weight;

        for (Vertex vertex in $path) {
          g_cost += state.getTimeConsume(edge, edge.type);
        }
      } else if (edge.type == Transportation.walk) {
        heuristics = Heuristics(state: state, type: Transportation.walk);
        weight = heuristics.mainFun();
        w_cost = weight;

        for (Vertex vertex in $path) {
          g_cost += state.getTimeConsume(edge, edge.type);
        }
      }
    }
    f_cost = g_cost + w_cost;
    return f_cost;
  }

  State algorithm(List<Vertex> start, Vertex end) {
    // ignore: prefer_function_declarations_over_variables
    Comparator<List<Vertex>> comparator =
        ($v1, $v2) => pathWeight($v1).compareTo(pathWeight($v2));

    PriorityQueue<List<Vertex>> priorityQueue =
        PriorityQueue<List<Vertex>>(comparator);

    List<Vertex> visited = [];
    priorityQueue.enQueue(start);

    while (priorityQueue.isNotEmpty) {
      priorityQueue.sort();
      List<Vertex>? path = priorityQueue.deQueue();

      Vertex? node = path?.last;
      state.path.add(node!.getPath());

      if (visited.contains(node)) continue;
      visited.add(node!);

      if (state.isFinal(node)) {
        print('state is');
        print(state.currentVertex);
        return state;
      } else {
        List<State> adjacent = state.getNextStates();
        for (State node2 in adjacent) {
          print('adjacent');
          print(node2.currentHealth);
          Vertex node3 = node2.currentVertex;
          List<Vertex> new_path = List.from(path!);

          new_path.add(node3);

          priorityQueue.enQueue(new_path);
        }
      }
    }

    return state;
  }
}
