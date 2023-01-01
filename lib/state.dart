import 'dart:io';

import 'package:isa/data_structure/graph.dart';

class State {
  final int initHealth;
  final int initMoney;
  List<String> path;
  final AdjacencyList graph;
  final List<Edge> availableMoves;
  final Vertex currentVertex;
  State({
    required this.initHealth,
    required this.initMoney,
    required this.path,
    required this.graph,
    required this.availableMoves,
    required this.currentVertex,
  });

  State copyWith({
    int? initHealth,
    int? initMoney,
    List<String>? path,
    AdjacencyList? graph,
    List<Edge>? availableMoves,
    Vertex? currentVertex,
  }) {
    return State(
      initHealth: initHealth ?? this.initHealth,
      initMoney: initMoney ?? this.initMoney,
      path: path ?? this.path,
      graph: graph ?? this.graph,
      availableMoves: availableMoves ?? this.availableMoves,
      currentVertex: currentVertex ?? this.currentVertex,
    );
  }

  double getMoneyConsume(Edge edge) {
    double moneyConsume = 0;
    if (edge.type == Transportation.walk) {
      moneyConsume = 0;
    } else if (edge.type == Transportation.bus) {
      ///TODO: vertex name or bus station name
      if (edge.source.vertexName == edge.destination.vertexName) {
        moneyConsume = 0;
      } else {
        moneyConsume = 400;
      }
    } else if (edge.type == Transportation.taxi) {
      moneyConsume = edge.distance * 1000;
    }
    return moneyConsume;
  }

  double getHealthConsume(Edge edge) {
    double healthConsume = 0;
    if (edge.type == Transportation.walk) {
      healthConsume = edge.distance * 10;
    } else if (edge.type == Transportation.bus) {
      healthConsume = edge.distance * 5;
    } else if (edge.type == Transportation.taxi) {
      healthConsume = edge.distance * 10 * -1;
    }
    return healthConsume;
  }

  double getTimeConsume(Edge edge) {
    double timeConsume = 0;
    if (edge.type == Transportation.walk) {
      timeConsume = edge.distance * edge.walkingSpeed;
    } else if (edge.type == Transportation.bus) {
      timeConsume =
          edge.source.busWaitingTime + (edge.distance * edge.busSpeed);
    } else if (edge.type == Transportation.taxi) {
      timeConsume =
          edge.source.taxiWaitingTime + (edge.distance * edge.taxiSpeed);
    }
    return timeConsume;
  }

  bool isFinal(Vertex vertex) {
    if (vertex.vertexName == 'home') {
      return true;
    }
    return false;
  }

  void printState() {
    //print the structure attributes values
    stdout.write("path: ");
    for (var element in path) {
      if (element == path.last) {
        stdout.write("$element\n");
      } else {
        stdout.write("$element -> ");
      }
    }
  }

  List<Edge> checkMoves() {
    List<Edge> availableMoves = [];
    List<Edge> moves = graph.edges(currentVertex);
    for (Edge edge in moves) {
      double health = currentVertex.currentHealth - getHealthConsume(edge);
      double money = currentVertex.currentMoney - getMoneyConsume(edge);
      if (money > 0 && health > 0) {
        availableMoves.add(edge);
      }
    }
    return availableMoves;
  }

  List<State> getNextState() {
    List<State> nextState = <State>[];
    availableMoves.addAll(checkMoves());
    for (var edges in availableMoves) {
      State state = copyWith();
      state.move(edges);
      nextState.add(state);
    }
    return nextState;
  }

  void move(Edge edge) {
    double health = getHealthConsume(edge);
    double money = getMoneyConsume(edge);
    double time = getTimeConsume(edge);
    edge.copyWith(
      destination: edge.destination.copyWith(
        currentHealth: edge.destination.currentHealth - health,
        currentMoney: edge.destination.currentMoney - money,
        consumedTime: edge.destination.consumedTime + time,
      ),
    );
  }
  // A *
  // heuristics
}
