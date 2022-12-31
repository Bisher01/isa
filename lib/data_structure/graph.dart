// Copyright (c) 2022 Razeware LLC
// For full license & permission details, see LICENSE.

class Vertex {
  const Vertex({
    required this.index,
    required this.vertexName,
    required this.busWaitingTime,
    required this.taxiWaitingTime,
    this.currentHealth = 0,
    this.currentMoney = 0,
    this.consumedTime = 0,
  });

  final int index;
  // if the vertexName== 'home' then
  // we have arrived at our destination
  final String vertexName;
  // in seconds
  final double busWaitingTime;
  // in seconds
  final double taxiWaitingTime;
  final double currentHealth;
  final double currentMoney;
  final double consumedTime;

  @override
  String toString() =>
      "Vertex(Current Health: $currentHealth, Current Money: $currentMoney, Consumed Time: $consumedTime)";

  String getPath() => "Station(num: $index, Station Name: $vertexName)";

  bool isEqual(Vertex vertex) {
    return busWaitingTime == vertex.busWaitingTime &&
        taxiWaitingTime == vertex.taxiWaitingTime &&
        currentHealth == vertex.currentHealth &&
        currentMoney == vertex.currentMoney &&
        consumedTime == vertex.consumedTime &&
        vertexName == vertex.vertexName;
  }

  Vertex copyWith({
    final int? index,
    final String? vertexName,
    final double? busWaitingTime,
    final double? taxiWaitingTime,
    final double? currentHealth,
    final double? currentMoney,
    final double? consumedTime,
  }) {
    return Vertex(
      index: index ?? this.index,
      vertexName: vertexName ?? this.vertexName,
      busWaitingTime: busWaitingTime ?? this.busWaitingTime,
      taxiWaitingTime: taxiWaitingTime ?? this.taxiWaitingTime,
      currentHealth: currentHealth ?? this.currentHealth,
      currentMoney: currentMoney ?? this.currentMoney,
      consumedTime: consumedTime ?? this.consumedTime,
    );
  }
}

class Edge {
  const Edge({
    required this.source,
    required this.destination,
    required this.distance,
    required this.busSpeed,
    required this.taxiSpeed,
    required this.busStationName,
    required this.type,
  });

  final Vertex source;
  final Vertex destination;
  // in kilometers
  final double distance;
  // in Km/h
  final double busSpeed;
  // in Km/h
  final double taxiSpeed;
  // in Km/h
  final double walkingSpeed = 5.5;
  final String? busStationName;
  final Transportation type;

  Edge copyWith({
    final Vertex? source,
    final Vertex? destination,
    final double? distance,
    final double? busSpeed,
    final double? taxiSpeed,
    final double? walkingSpeed,
    final String? busStationName,
    final Transportation? type,
  }) {
    return Edge(
      source: source ?? this.source,
      destination: destination ?? this.destination,
      distance: distance ?? this.distance,
      busSpeed: busSpeed ?? this.busSpeed,
      taxiSpeed: taxiSpeed ?? this.taxiSpeed,
      busStationName: busStationName ?? this.busStationName,
      type: type ?? this.type,
    );
  }
}

enum EdgeType { directed, undirected }

enum Transportation { bus, walk, taxi, none }

abstract class Graph {
  Iterable<Vertex> get vertices;

  Vertex createVertex(
    String vertexName,
    double busWaitingTime,
    double taxiWaitingTime,
    double currentHealth,
    double currentMoney,
    double consumedTime,
  );

  void addEdge(
    Vertex source,
    Vertex destination,
    double distance,
    double busSpeed,
    double taxiSpeed,
    String? busStationName,
    Transportation type,
  );

  List<Edge> edges(Vertex source);

  double? distance(Vertex source, Vertex destination);
  double? busSpeed(Vertex source, Vertex destination);
  double? taxiSpeed(Vertex source, Vertex destination);
  String? busStationName(Vertex source, Vertex destination);
  Transportation? type(Vertex source, Vertex destination);
}

class AdjacencyList implements Graph {
  Map<Vertex, List<Edge>> connections;
  int nextIndex;
  AdjacencyList({required this.connections, this.nextIndex = 0});

  @override
  Iterable<Vertex> get vertices => connections.keys;

  @override
  Vertex createVertex(
    String vertexName,
    double busWaitingTime,
    double taxiWaitingTime,
    double currentHealth,
    double currentMoney,
    double consumedTime,
  ) {
    final vertex = Vertex(
      index: nextIndex,
      vertexName: vertexName,
      busWaitingTime: busWaitingTime,
      taxiWaitingTime: taxiWaitingTime,
      currentHealth: currentHealth,
      currentMoney: currentMoney,
      consumedTime: consumedTime,
    );
    nextIndex++;
    connections[vertex] = [];
    return vertex;
  }

  @override
  void addEdge(
    Vertex source,
    Vertex destination,
    double distance,
    double busSpeed,
    double taxiSpeed,
    String? busStationName,
    Transportation type,
  ) {
    connections[source]?.add(
      Edge(
        source: source,
        destination: destination,
        distance: distance,
        busSpeed: busSpeed,
        taxiSpeed: taxiSpeed,
        busStationName: busStationName,
        type: type,
      ),
    );
    // if (edgeType == EdgeType.undirected) {
    //   _connections[destination]?.add(
    //     Edge(destination, source, weight),
    //   );
  }

  @override
  List<Edge> edges(Vertex source) {
    return connections[source] ?? [];
  }

  @override
  String toString() {
    final result = StringBuffer();
    connections.forEach((vertex, edges) {
      final destinations = edges.map((edge) {
        return edge.destination;
      }).join(', ');
      result.writeln('$vertex --> $destinations');
    });
    return result.toString();
  }
  // @override
  // double? weight(
  //   Vertex source,
  //   Vertex destination,
  // ) {
  //   final match = edges(source).where((edge) {
  //     return edge.destination == destination;
  //   });
  //   if (match.isEmpty) return null;
  //   return match.first.weight;
  // }

  @override
  double? busSpeed(Vertex source, Vertex destination) {
    final match = edges(source).where((edge) {
      return edge.destination.isEqual(destination);
    });
    if (match.isEmpty) return null;
    return match.first.busSpeed;
  }

  @override
  String? busStationName(Vertex source, Vertex destination) {
    final match = edges(source).where((edge) {
      return edge.destination.isEqual(destination);
    });
    if (match.isEmpty) return null;
    return match.first.busStationName;
  }

  @override
  double? distance(Vertex source, Vertex destination) {
    final match = edges(source).where((edge) {
      return edge.destination.isEqual(destination);
    });
    if (match.isEmpty) return null;
    return match.first.distance;
  }

  @override
  double? taxiSpeed(Vertex source, Vertex destination) {
    final match = edges(source).where((edge) {
      return edge.destination.isEqual(destination);
    });
    if (match.isEmpty) return null;
    return match.first.taxiSpeed;
  }

  @override
  Transportation? type(Vertex source, Vertex destination) {
    final match = edges(source).where((edge) {
      return edge.destination.isEqual(destination);
    });
    if (match.isEmpty) return null;
    return match.first.type;
  }
}

/*
class AdjacencyMatrix<E> implements Graph<E> {
  final List<Vertex<E>> _vertices = [];
  final List<List<double?>?> _weights = [];
  var _nextIndex = 0;

  @override
  Iterable<Vertex<E>> get vertices => _vertices;

  @override
  Vertex<E> createVertex(E data) {
    final vertex = Vertex(
      index: _nextIndex,
      data: data,
    );
    _nextIndex++;
    _vertices.add(vertex);
    for (var i = 0; i < _weights.length; i++) {
      _weights[i]?.add(null);
    }
    final row = List<double?>.filled(
      _vertices.length,
      null,
      growable: true,
    );
    _weights.add(row);
    return vertex;
  }

  @override
  void addEdge(
    Vertex<E> source,
    Vertex<E> destination, {
    EdgeType edgeType = EdgeType.undirected,
    double? weight,
  }) {
    _weights[source.index]?[destination.index] = weight;
    if (edgeType == EdgeType.undirected) {
      _weights[destination.index]?[source.index] = weight;
    }
  }

  @override
  List<Edge<E>> edges(Vertex<E> source) {
    List<Edge<E>> edges = [];
    for (var column = 0; column < _weights.length; column++) {
      final weight = _weights[source.index]?[column];
      if (weight == null) continue;
      final destination = _vertices[column];
      edges.add(Edge(source, destination, weight));
    }
    return edges;
  }

  @override
  double? weight(Vertex<E> source, Vertex<E> destination) {
    return _weights[source.index]?[destination.index];
  }

  @override
  String toString() {
    final output = StringBuffer();
    for (final vertex in _vertices) {
      output.writeln('${vertex.index}: ${vertex.data}');
    }
    for (int i = 0; i < _weights.length; i++) {
      for (int j = 0; j < _weights.length; j++) {
        final value = (_weights[i]?[j] ?? '.').toString();
        output.write(value.padRight(6));
      }
      output.writeln();
    }
    return output.toString();
  }
}
*/
