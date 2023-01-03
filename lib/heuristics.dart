import 'dart:math';

import 'package:isa/data_structure/graph.dart';
import 'package:isa/data_structure/priority_queue.dart';
import 'package:isa/data_structure/queue.dart';
import 'package:isa/map/map.dart';
import 'package:isa/state.dart';

class heuristics {
  final int currentHealth;
  final int currentMoney;
  List<String> path;
  final AdjacencyList graph;
  final List<Edge> availableMoves = [];
  final Vertex currentVertex;
  final Edge? previousEdge; //null
  Transportation type;
  heuristics(this.currentHealth, this.currentMoney, this.path, this.graph,
      this.currentVertex, this.previousEdge, this.type);
  void mainfun() {
    /**
     * Map<String, String> ListFinalAllInfos = {'stackoverflow': 'one', 'google': 'two'};
String key = ListFinalAllInfos.containsKey("stackoverflow"); // search for the key. for example stackoverflow
String value = ListFinalAllInfos[key]; // get the value for the key, value will be 'one'
if(ListFinalAllInfos.containsKey(value)){ //check if there is a key which is the value you grabbed
  return true;
}
     */

    /**
     * import 'package:sortedmap/sortedmap.dart';

main() {
  var map = new SortedMap(Ordering.byValue());
  
  map.addAll({
    "a": 3,
    "b": 2,
    "c": 4,
    "d": 1
  });
  
  print(map.lastKeyBefore("c")); // a
  print(map.firstKeyAfter("d")); // b
  
}
     */

    State cost = State(
        currentHealth: currentHealth,
        currentMoney: currentMoney,
        path: path,
        graph: graph,
        currentVertex: currentVertex,
        previousEdge: previousEdge);
    RoadMap map = RoadMap();
    double h = 0;
    AdjacencyList a = map.getGraph();
            QueueList queue = new QueueList();

    a.connections.forEach((key, value) {
      PriorityQueue vertixQueue =
          PriorityQueue(elements: [], priority: Priority.min);
      value.forEach((element) {
        if (element.destination.vertexName == 'home') {
          h = cost.getTimeConsume(element, type);
          vertixQueue.enqueue(h);
        }
      });

      queue.enqueue(key);
      while(q.)

    });
  }
}
