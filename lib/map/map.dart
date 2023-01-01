import 'package:isa/data_structure/graph.dart';

class RoadMap {
  AdjacencyList graph = AdjacencyList(connections: {});
  void getGraph() {
    ///Stations
    Vertex college = graph.createVertex('college', 100, 60);
    Vertex home = graph.createVertex('home', 0, 0);
    Vertex mhajreen = graph.createVertex('mhajreen', 200, 80);
    Vertex malki = graph.createVertex('malki', 50, 20);
    Vertex kafrsouseh = graph.createVertex('kafrsouseh', 45, 30);
    Vertex medan = graph.createVertex('medan', 90, 75);
    Vertex naher3esheh = graph.createVertex('naher 3esheh', 300, 250);
    Vertex karajalst = graph.createVertex('karaj alst', 240, 190);
    Vertex jesrAlra2ees = graph.createVertex('jesr alra2ees', 400, 300);

    ///Roads
    Edge collegeNahr3eshe = graph.addEdge(college, naher3esheh, 4, 40, 60,
        'mhajreen sena3a', Transportation.none);
    Edge collegeMedan1 = graph.addEdge(
        college, medan, 2, 50, 70, 'mhajreen sena3a', Transportation.none);
    Edge collegeMedan2 = graph.addEdge(
        college, medan, 2, 30, 70, 'sena3a bus', Transportation.none);
    Edge collegeKarajalst = graph.addEdge(
        college, karajalst, 10, 40, 60, 'sena3a bus', Transportation.none);
    Edge kafrsousehHome = graph.addEdge(
        kafrsouseh, home, 1, 50, 60, 'kafrsouseh', Transportation.none);
    Edge JesrMhajreen = graph.addEdge(jesrAlra2ees, mhajreen, 8, 45, 52,
        'mhajreen sena3a', Transportation.none);
    Edge MalkiHome = graph.addEdge(malki, home, 7, 110, 70,
        'mhajreen sena3a', Transportation.none);
  }
}
