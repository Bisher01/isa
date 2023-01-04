import 'package:isa/data_structure/graph.dart';
import 'package:isa/data_structure/priority_queue.dart';
import 'package:isa/data_structure/queue.dart';
import 'package:isa/map/map.dart';
import 'package:isa/state.dart';

class Heuristics {
  final double currentHealth;
  final double currentMoney;
  final double consumedTime;
  List<String> path;
  final AdjacencyList graph;
  final List<Edge> availableMoves = [];
  final Vertex currentVertex;
  final Edge? previousEdge; //null
  Transportation type;

  Heuristics(
    this.currentHealth,
    this.currentMoney,
    this.consumedTime,
    this.path,
    this.graph,
    this.currentVertex,
    this.previousEdge,
    this.type,
  );

  void mainFun() {
    State cost = State(
      currentHealth: currentHealth,
      currentMoney: currentMoney,
      consumedTime: consumedTime,
      path: path,
      graph: graph,
      currentVertex: currentVertex,
      previousEdge: previousEdge,
    );

    RoadMap map = RoadMap();
    double h = 0;
    AdjacencyList a = map.getGraph();
    AdjacencyList edges = AdjacencyList(connections: {});
    QueueList queue = QueueList();

    a.connections.forEach(
      (key, value) {
        PriorityQueue vertexQueue =
            PriorityQueue(elements: [], priority: Priority.min);
        for (var element in value) {
          if (element.destination.vertexName == 'home') {
            h = cost.getTimeConsume(element, type);
            vertexQueue.enqueue(h);
          }
        }

        queue.enqueue(key);
        while (!queue.isEmpty) {
          Vertex node = queue.dequeue();
          List<Edge> childrenEdges = edges.edges(node);
          for (var childrenEdge in childrenEdges) {
              childrenEdge.destination.parent = node;
              queue.enqueue(childrenEdge.destination);
              List<Edge> childrenEdgesForChild =
                  edges.edges(childrenEdge.destination);
              for (var childrenEdgeForChild in childrenEdgesForChild) {
                  if (childrenEdgeForChild.destination.vertexName == 'home') {
                    queue.dequeue();
                    h = cost.getTimeConsume(childrenEdgeForChild, type);
                    while (true) {
                      h += cost.getTimeConsume(
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
