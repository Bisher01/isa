import 'package:isa/data_structure/graph.dart';

class RoadMap {
  AdjacencyList graph = AdjacencyList(connections: {});
  Vertex? college;
  Vertex? home;
  Vertex? mhajreen;
  Vertex? malki;
  Vertex? medan;
  AdjacencyList getGraph() {
    ///Stations
    college = graph.createVertex('college', 100, 60);
    home = graph.createVertex('home', 0, 0);
    mhajreen = graph.createVertex('mhajreen', 200, 80);
    malki = graph.createVertex('malki', 50, 20);
    medan = graph.createVertex('medan', 90, 75);
    // Vertex naher3esheh = graph.createVertex('naher 3esheh', 300, 250);
    // Vertex karajalst = graph.createVertex('karaj alst', 240, 190);
    // Vertex jesrAlra2ees = graph.createVertex('jesr alra2ees', 400, 300);
    // Vertex kafrsouseh = graph.createVertex('kafrsouseh', 45, 30);

    ///Roads

    Edge collegeMedan = graph.addEdge(
        college!, medan!, 7, 20, 50, 'college medan', Transportation.none);

    Edge collegeHome = graph.addEdge(
        college!, home!, 6, 50, 80, 'college home', Transportation.none);

    Edge collegeMhajreen = graph.addEdge(college!, mhajreen!, 2, 30, 70,
        'college mhajreen', Transportation.none);

    Edge mhajreenMalki = graph.addEdge(
        mhajreen!, malki!, 2, 40, 70, 'mhajreen malki', Transportation.none);

    Edge medanHome = graph.addEdge(
        medan!, home!, 3, 20, 50, 'medan home', Transportation.none);

    Edge MalkiHome = graph.addEdge(
        malki!, home!, 5, 70, 90, 'malki home', Transportation.none);

    // Edge collegeNahr3eshe = graph.addEdge(college, naher3esheh, 4, 40, 60,
    //     'mhajreen sena3a', Transportation.none);

    // Edge collegeKarajalst = graph.addEdge(
    //     college, karajalst, 10, 40, 60, 'sena3a bus', Transportation.none);
    // Edge kafrsousehHome = graph.addEdge(
    //     kafrsouseh, home, 1, 50, 60, 'kafrsouseh', Transportation.none);
    // Edge JesrMhajreen = graph.addEdge(jesrAlra2ees, mhajreen, 8, 45, 52,
    //     'mhajreen sena3a', Transportation.none);

    return graph;
  }
}
