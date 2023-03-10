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
    double time = 0;
    double health = 0;
    double money = 0;

    List<Edge> availableMove = state.checkMoves();
    for (Edge edge in availableMove) {
      if (edge.type == Transportation.taxi) {
        heuristics = Heuristics(state: state, type: Transportation.taxi);
        weight = heuristics.mainFun();
        w_cost = weight;

        for (Vertex vertex in $path) {
          time += state.getTimeConsume(edge, edge.type);
          money += state.getMoneyConsume(edge, edge.type);
          health += state.getHealthConsume(edge, edge.type);
          g_cost += (time + money + health)/3;
        }
      } else if (edge.type == Transportation.bus) {
        heuristics = Heuristics(state: state, type: Transportation.bus);
        weight = heuristics.mainFun();
        w_cost = weight;

        for (Vertex vertex in $path) {
          time += state.getTimeConsume(edge, edge.type);
          money += state.getMoneyConsume(edge, edge.type);
          health += state.getHealthConsume(edge, edge.type);
          g_cost +=  (time + money + health)/3;
        }
      } else if (edge.type == Transportation.walk) {
        heuristics = Heuristics(state: state, type: Transportation.walk);
        weight = heuristics.mainFun();
        w_cost = weight;

        for (Vertex vertex in $path) {
          time += state.getTimeConsume(edge, edge.type);
          money += state.getMoneyConsume(edge, edge.type);
          health += state.getHealthConsume(edge, edge.type);
          g_cost += (time + money + health)/3;
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

      if (state.isFinal()) {
        print('state is');
        print(state);
        return state;
      }

      if (visited.contains(node)) continue;
      state.path.add('${node!.getPath()} - ${state}');

      visited.add(node);

      List<State> adjacent = state.getNextStates();
      for (State node2 in adjacent) {
        state = node2.copyWith();
        List<Vertex> new_path = List.from(path!);

        new_path.add(state.currentVertex);

        priorityQueue.enQueue(new_path);
      }
    }

    return state;
  }
}
