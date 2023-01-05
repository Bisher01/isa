import 'dart:io';

import 'package:isa/data_structure/graph.dart';

// you are idiot
// and i will judge you
class State {
  double currentHealth;
  double currentMoney;
  double consumedTime;
  List<String> path;
  final AdjacencyList graph;
  final AdjacencyList? map;
  final List<Edge> availableMoves = [];
  Vertex currentVertex;
  Edge? previousEdge; //null
  State({
    required this.currentHealth,
    required this.currentMoney,
    required this.consumedTime,
    required this.path,
    required this.graph,
    this.map,
    required this.currentVertex,
    this.previousEdge,
  });

  // graph.addEdge(source, destination, distance, busSpeed, taxiSpeed, busStationName, type);
  // graph.createVertex(vertexName, busWaitingTime, taxiWaitingTime, currentHealth, currentMoney, consumedTime);
  State copyWith(
      {double? currentHealth,
      double? currentMoney,
      double? consumedTime,
      List<String>? path,
      AdjacencyList? graph,
      List<Edge>? availableMoves,
      Vertex? currentVertex,
      Edge? previousEdge}) {
    return State(
      currentHealth: currentHealth ?? this.currentHealth,
      currentMoney: currentMoney ?? this.currentMoney,
      consumedTime: consumedTime ?? this.consumedTime,
      path: path ?? this.path,
      graph: graph ?? this.graph,
      map: map,
      currentVertex: currentVertex ?? this.currentVertex,
      previousEdge: previousEdge ?? this.previousEdge,
    );
  }

  double getMoneyConsume(Edge edge, Transportation type) {
    double moneyConsume = 0;
    if (type == Transportation.walk) {
      moneyConsume = 0;
    } else if (type == Transportation.bus) {
      if (edge.busStationName == previousEdge?.busStationName) {
        moneyConsume = 0;
      } else {
        moneyConsume = 400;
      }
    } else if (type == Transportation.taxi) {
      moneyConsume = edge.distance * 1000;
    }
    return moneyConsume;
  }

  double getHealthConsume(Edge edge, Transportation type) {
    double healthConsume = 0;
    if (type == Transportation.walk) {
      healthConsume = edge.distance * 10;
    } else if (type == Transportation.bus) {
      healthConsume = edge.distance * 5;
    } else if (type == Transportation.taxi) {
      healthConsume = edge.distance * 10 * -1;
    }
    return healthConsume;
  }

  double getTimeConsume(Edge edge, Transportation type) {
    // in seconds
    double timeConsume = 0;
    if (type == Transportation.walk) {
      timeConsume = (edge.distance / edge.walkingSpeed) * 3600;
    } else if (type == Transportation.bus) {
      timeConsume =
          edge.source.busWaitingTime + ((edge.distance / edge.busSpeed) * 3600);
    } else if (type == Transportation.taxi) {
      timeConsume = edge.source.taxiWaitingTime +
          ((edge.distance / edge.taxiSpeed) * 3600);
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
    List<Edge> moves = map!.edges(currentVertex); //collage //<Edge>[..]
    for (Edge edge in moves) {
      // bus
      if (edge.busStationName != null) {
        double health =
            currentHealth - getHealthConsume(edge, Transportation.bus);
        double money = currentMoney - getMoneyConsume(edge, Transportation.bus);
        if (money > 0 && health > 0) {
          availableMoves.add(edge.copyWith(type: Transportation.bus));
        }
      }
      // taxi
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

  List<State> getNextStates() {
    print('currentHealth= $currentHealth || currentMoney= $currentMoney');
    print('before');
    print(graph.toString());
    print('==================');
    List<State> nextStates = <State>[];
    availableMoves.addAll(checkMoves());
    print('available moves = ${availableMoves.length}');
    for (var edges in availableMoves) {
      State state = copyWith();
      state.move(edges);
      print(state.graph.toString());
      nextStates.add(state);
    }
    print('currentHealth= $currentHealth || currentMoney= $currentMoney');
    print('after');
    print(graph.toString());
    return nextStates;
  }

  // source dest type
  void move(Edge edge) {
    double health = getHealthConsume(edge, edge.type);
    double money = getMoneyConsume(edge, edge.type);
    double time = getTimeConsume(edge, edge.type);
    currentHealth = currentHealth - health;
    currentMoney = currentMoney - money;
    consumedTime = consumedTime + time;
    currentVertex = edge.destination;
    previousEdge = edge;
    // AdjacencyList test = graph.copyWith();
    // test.createVertex(
    //   edge.destination.vertexName,
    //   edge.destination.busWaitingTime,
    //   edge.destination.taxiWaitingTime,
    // );
    // test.addEdge(
    //   currentVertex,
    //   edge.destination,
    //   edge.distance,
    //   edge.busSpeed,
    //   edge.taxiSpeed,
    //   edge.busStationName,
    //   edge.type,
    // );
  }
// A *
// heuristics
}
