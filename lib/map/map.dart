import 'package:isa/data_structure/graph.dart';

class RoadMap{
  AdjacencyList graph = AdjacencyList(connections:{});
  void getGraph(){
    Vertex collage = graph.createVertex('collage', 100, 60);
    Vertex home =graph.createVertex('home', 0, 0);
    Vertex mhajreen =graph.createVertex('mhajreen', 200, 80);
    Vertex malki =graph.createVertex('malki', 50, 20);
    Vertex kafrsouseh =graph.createVertex('kafrsouseh', 45, 30);
    Vertex medan =graph.createVertex('medan', 90, 75);
    Vertex naher3esheh =graph.createVertex('naher 3esheh', 300, 250);
    Vertex karajalst =graph.createVertex('karaj alst', 240, 190);

    graph.addEdge(collage, naher3esheh, 4, 40, 60, 'mhajreen sena3a', Transportation.none);

  }
}