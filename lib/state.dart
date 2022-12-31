import 'package:isa/data_structure/graph.dart';

class State {
  final int initHealth;
  final int initMoney;
  State({
    required this.initHealth,
    required this.initMoney,
  });

  List<String> path = [];
  final graph = AdjacencyList();

  double getMoneyConsume(Edge edge) {
    double moneyConsume = 0;
    if (edge.type == Transportation.walk) {
      moneyConsume = 0;
    } else if (edge.type == Transportation.bus) {
      moneyConsume = 400;
    } else {
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
    } else {
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
    } else {
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
  // get next state
  // check moves
  // A *
  // heuristics
}
