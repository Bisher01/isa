import 'dart:html';

import 'package:isa/data_structure/graph.dart';
import 'package:isa/data_structure/priority_queue.dart';
import 'package:isa/data_structure/queue.dart';
import 'package:isa/map/map.dart';
import 'package:isa/state.dart';

class Heuristics {
 State state;
 Transportation type;

  Heuristics(
    this.state,
    this.type,
  );

  double mainFun() {
   RoadMap map = RoadMap();
    double h = 0;
    AdjacencyList a = map.getGraph();
    AdjacencyList edges = AdjacencyList(connections: {});
    QueueList queue = QueueList();
         PriorityQueue<double> vertexQueue =
            PriorityQueue(elements: [], priority: Priority.min);

    a.connections.forEach(
      (key, value) {
        for (var element in value) {
          if (element.destination.vertexName == 'home') {
            h = state.getTimeConsume(element, type);
            vertexQueue.enqueue(h);
          }
        }

        queue.enqueue(key);
        while (!queue.isEmpty) {
          Vertex node = queue.dequeue();
          ///TODO: alissar {path.add(node.getPath()}
          List<Edge> childrenEdges = edges.edges(node);
          for (var childrenEdge in childrenEdges) {
              childrenEdge.destination.parent = node;
              queue.enqueue(childrenEdge.destination);
              List<Edge> childrenEdgesForChild =
                  edges.edges(childrenEdge.destination);
              for (var childrenEdgeForChild in childrenEdgesForChild) {
                  if (childrenEdgeForChild.destination.vertexName == 'home') {
                    queue.dequeue();
                    h = state.getTimeConsume(childrenEdgeForChild, type);
                    while (true) {
                      h += state.getTimeConsume(
                          edge(childrenEdge.destination,
                              childrenEdge.destination.parent!)!,
                          type);
                      node = childrenEdge.destination.parent!;
                      if (node == key) {
                        vertexQueue.enqueue(h);
                        break;
                      }
                    }
                  }
                }
            }
        }
      },
    );
   return vertexQueue.dequeue()!;
  }

  Edge? edge(Vertex v1, Vertex v2) {
    Edge? result;
    RoadMap map = RoadMap();
    AdjacencyList a = map.getGraph();
    a.connections.forEach((key, value) {
      for (var element in value) {
        if (element.source == v1 && element.destination == v2) {
          result = element;
        }
      }
    });
    return result;
  }
}
