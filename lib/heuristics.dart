import 'package:isa/data_structure/graph.dart';
import 'package:isa/map/map.dart';

class heuristics {
  void mainfun() {
    RoadMap map = RoadMap();
    AdjacencyList a = map.getGraph();
    var n = 1;
    a.connections.forEach((key, value) {
      value.forEach((element) {
        if (element.destination.vertexName == 'home') {
          key.heuristic = 1;
        }
      });

      // print(value.toString());
      // value.forEach((element) {
      //   if (element) {}
      // });
    });
  }
}
