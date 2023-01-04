// Copyright (c) 2022 Razeware LLC
// For full license & permission details, see LICENSE.

import 'dart:convert';

class Vertex {
  Vertex(
      {required this.index,
      required this.vertexName,
      required this.busWaitingTime,
      required this.taxiWaitingTime,
      this.parent});
  Vertex? parent;
  final int index;
  // if the vertexName== 'home' then
  // we have arrived at our destination
  final String vertexName;
  // in seconds
  final double busWaitingTime;
  // in seconds
  final double taxiWaitingTime;

  @override
  String toString() => "$index $vertexName";

  String getPath() => "Station(num: $index, Station Name: $vertexName)";

  bool isEqual(Vertex vertex) {
    return busWaitingTime == vertex.busWaitingTime &&
        taxiWaitingTime == vertex.taxiWaitingTime &&
        vertexName == vertex.vertexName;
  }

  Vertex copyWith({
    final int? index,
    final String? vertexName,
    final double? busWaitingTime,
    final double? taxiWaitingTime,
  }) {
    return Vertex(
      index: index ?? this.index,
      vertexName: vertexName ?? this.vertexName,
      busWaitingTime: busWaitingTime ?? this.busWaitingTime,
      taxiWaitingTime: taxiWaitingTime ?? this.taxiWaitingTime,
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

  @override
  String toString() {
    return 'Edge{source: $source, destination: $destination, distance: $distance, busSpeed: $busSpeed, taxiSpeed: $taxiSpeed, walkingSpeed: $walkingSpeed, busStationName: $busStationName, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Edge &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          destination == other.destination &&
          distance == other.distance &&
          busSpeed == other.busSpeed &&
          taxiSpeed == other.taxiSpeed &&
          walkingSpeed == other.walkingSpeed &&
          busStationName == other.busStationName;

  @override
  int get hashCode =>
      source.hashCode ^
      destination.hashCode ^
      distance.hashCode ^
      busSpeed.hashCode ^
      taxiSpeed.hashCode ^
      walkingSpeed.hashCode ^
      busStationName.hashCode ^
      type.hashCode;
}

enum EdgeType { directed, undirected }

enum Transportation { bus, walk, taxi, none }

abstract class Graph {
  Iterable<Vertex> get vertices;

  Vertex createVertex(
    String vertexName,
    double busWaitingTime,
    double taxiWaitingTime,
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
  AdjacencyList({
    required this.connections,
    this.nextIndex = 0,
  });

  List<Edge> deepCopy(List<Edge> edges) {
    List<Edge> newList = [];
    for (var el in edges) {
      newList.add(el);
    }
    return newList;
  }

  Map<Vertex, List<Edge>> deepCopyMap(Map<Vertex, List<Edge>> map) {
    Map<Vertex, List<Edge>> newMap = {};
    map.forEach((key, value) {
      newMap.addAll({key: deepCopy(value)});
    });
    return newMap;
  }

  AdjacencyList copyWith({
    Map<Vertex, List<Edge>>? connections,
  }) {
    return AdjacencyList(
      connections: deepCopyMap(this.connections),
    );
  }

  @override
  Iterable<Vertex> get vertices => connections.keys;

  @override
  Vertex createVertex(
    String vertexName,
    double busWaitingTime,
    double taxiWaitingTime,
  ) {
    final vertex = Vertex(
      index: nextIndex,
      vertexName: vertexName,
      busWaitingTime: busWaitingTime,
      taxiWaitingTime: taxiWaitingTime,
    );
    nextIndex++;
    connections[vertex] = [];
    return vertex;
  }

  @override
  Edge addEdge(
    Vertex source,
    Vertex destination,
    double distance,
    double busSpeed,
    double taxiSpeed,
    String? busStationName,
    Transportation type,
  ) {
    final edge = Edge(
      source: source,
      destination: destination,
      distance: distance,
      busSpeed: busSpeed,
      taxiSpeed: taxiSpeed,
      busStationName: busStationName,
      type: type,
    );
    connections[source]?.add(edge);
    return edge;
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
