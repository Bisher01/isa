import 'package:isa/data_structure/graph.dart';
import 'package:isa/data_structure/priority_queue.dart';
import 'package:isa/data_structure/queue.dart';
import 'package:isa/map/map.dart';
import 'package:isa/state.dart';

class Heuristics {
  final int currentHealth;
  final int currentMoney;
  final int consumedTime;
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

  void mainfun() {
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
      while (!queue.isEmpty) {
        Vertex node = queue.dequeue();
        List<Edge> childrenedges = edges.edges(node);
        childrenedges.forEach((childrenedge) {
          childrenedge.destination.parent = node;
          queue.enqueue(childrenedge.destination);
          List<Edge> childrenEdgesForChild =
              edges.edges(childrenedge.destination);
          childrenEdgesForChild.forEach((childrenEdgeForChild) {
            if (childrenEdgeForChild.destination.vertexName == 'home') {
              queue.dequeue();
              h = cost.getTimeConsume(childrenEdgeForChild, type);
              while (true) {
                h += cost.getTimeConsume(
                    edge(childrenedge.destination,
                        childrenedge.destination.parent!)!,
                    type);
                node = childrenedge.destination.parent!;
                if (node == key) {
                  vertixQueue.enqueue(h);
                  break;
                }
              }
            }
          });
        });
      }
    });
  }

  Edge? edge(Vertex v1, Vertex v2) {
    Edge? result;
    RoadMap map = RoadMap();
    AdjacencyList a = map.getGraph();
    a.connections.forEach((key, value) {
      value.forEach((element) {
        if (element.source == v1 && element.destination == v2) {
          result = element;
        }
      });
    });
    return result;
  }
}
