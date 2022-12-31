import 'package:isa/data_structure/graph.dart';

class State {
  final int initHealth;
  final int initMoney;
  List<String> path;
  final AdjacencyList graph;
  final List<Vertex> availableMoves;
  State({
    required this.initHealth,
    required this.initMoney,
    required this.path,
    required this.graph,
    required this.availableMoves,
  });

  State copyWith({
    int? initHealth,
    int? initMoney,
    List<String>? path,
    AdjacencyList? graph,
    List<Vertex>? availableMoves,
  }) {
    return State(
      initHealth: initHealth ?? this.initHealth,
      initMoney: initMoney ?? this.initMoney,
      path: path ?? this.path,
      graph: graph ?? this.graph,
      availableMoves: availableMoves ?? this.availableMoves,
    );
  }

  double getMoneyConsume(Edge edge) {
    double moneyConsume = 0;
    if (edge.type == Transportation.walk) {
      moneyConsume = 0;
    } else if (edge.type == Transportation.bus) {
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

  move(Edge edge) {
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

  bool checkAvailableVertex() {
    return false;
  }

  List<Vertex> checkMoves() {
    List<Vertex> availableMoves = [];

    return availableMoves;
  }
  // get next state
  // check moves
  // A *
  // heuristics
}
