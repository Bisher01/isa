import 'dart:io';

import 'package:isa/data_structure/graph.dart';

// you are idiot
// and i will judge you
class State {
  final int currentHealth;
  final int currentMoney;
  List<String> path;
  final AdjacencyList graph;
  final List<Edge> availableMoves = [];
  final Vertex currentVertex;
  final Edge? previousEdge; //null
  State({
    required this.currentHealth,
    required this.currentMoney,
    required this.path,
    required this.graph,
    required this.currentVertex,
    required this.previousEdge,
  });

  // graph.addEdge(source, destination, distance, busSpeed, taxiSpeed, busStationName, type);
  // graph.createVertex(vertexName, busWaitingTime, taxiWaitingTime, currentHealth, currentMoney, consumedTime);
  State copyWith(
      {int? currentHealth,
      int? currentMoney,
      List<String>? path,
      AdjacencyList? graph,
      List<Edge>? availableMoves,
      Vertex? currentVertex,
      Edge? previousEdge}) {
    return State(
      currentHealth: currentHealth ?? this.currentHealth,
      currentMoney: currentMoney ?? this.currentMoney,
      path: path ?? this.path,
      graph: graph ?? this.graph,
      currentVertex: currentVertex ?? this.currentVertex,
      previousEdge: previousEdge ?? this.previousEdge,
    );
  }

  double getMoneyConsume(Edge edge, Transportation type) {
    double moneyConsume = 0;
    if (edge.type == Transportation.walk) {
      moneyConsume = 0;
    } else if (edge.type == Transportation.bus) {
      if (edge.busStationName == previousEdge?.busStationName) {
        moneyConsume = 0;
      } else {
        moneyConsume = 400;
      }
    } else if (edge.type == Transportation.taxi) {
      moneyConsume = edge.distance * 1000;
    }
    return moneyConsume;
  }

  double getHealthConsume(Edge edge, Transportation type) {
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

  double getTimeConsume(Edge edge, Transportation type) {
    // in seconds
    double timeConsume = 0;
    if (edge.type == Transportation.walk) {
      timeConsume = edge.distance * edge.walkingSpeed * 3600;
    } else if (edge.type == Transportation.bus) {
      timeConsume =
          edge.source.busWaitingTime + (edge.distance * edge.busSpeed * 3600);
    } else if (edge.type == Transportation.taxi) {
      timeConsume =
          edge.source.taxiWaitingTime + (edge.distance * edge.taxiSpeed * 3600);
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
    List<Edge> moves = graph.edges(currentVertex); //collage //<Edge>[..]
    for (Edge edge in moves) {
      if (edge.busStationName != null) {
        double health =
            currentHealth - getHealthConsume(edge, Transportation.bus);
        double money = currentMoney - getMoneyConsume(edge, Transportation.bus);
        if (money > 0 && health > 0) {
          availableMoves.add(edge.copyWith(type: Transportation.bus));
        }
      }
      if (edge.busStationName != null) {
        double health =
            currentHealth - getHealthConsume(edge, Transportation.taxi);
        double money =
            currentMoney - getMoneyConsume(edge, Transportation.taxi);
        if (money > 0 && health > 0) {
          availableMoves.add(edge.copyWith(type: Transportation.taxi));
        }
      }
      double health =
          currentHealth - getHealthConsume(edge, Transportation.walk);
      if (health > 0) {
        availableMoves.add(edge.copyWith(type: Transportation.walk));
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

  // source dest type
  void move(Edge edge) {
    double health = getHealthConsume(edge, edge.type);
    double money = getMoneyConsume(edge, edge.type);
    double time = getTimeConsume(edge, edge.type);
    Edge newEdge = edge.copyWith(
      destination: edge.destination.copyWith(
        currentHealth: edge.destination.currentHealth - health,
        currentMoney: edge.destination.currentMoney - money,
        consumedTime: edge.destination.consumedTime + time,
      ),
    );
    graph.createVertex(
      edge.destination.vertexName,
      edge.destination.busWaitingTime,
      edge.destination.taxiWaitingTime,
      currentHealth: newEdge.destination.currentHealth,
      currentMoney: newEdge.destination.currentMoney,
      consumedTime: newEdge.destination.consumedTime,
    );
    graph.addEdge(
      currentVertex,
      newEdge.destination,
      newEdge.distance,
      newEdge.busSpeed,
      newEdge.taxiSpeed,
      newEdge.busStationName,
      newEdge.type,
    );
  }
  // A *
  // heuristics
}
