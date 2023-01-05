import 'dart:core';

class StackCollection<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);
  void addAll(Iterable<E> elements) => _list.addAll(elements);

  E? pop() => (isEmpty) ? null : _list.removeLast();
  E? get peek => (isEmpty) ? null : _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  int get length => _list.length;
  void clear() => _list.clear();

  @override
  String toString() => _list.toString();
}

class PriorityQueue<E> {
  final _queue = <E>[];
  Comparator<E> comparator;

  PriorityQueue(this.comparator);

  void enQueue(E value) {
    _queue.add(value);
    sort();
  }

  E? deQueue() => (isEmpty) ? null : _queue.removeAt(0);
  E? get peek => (isEmpty) ? null : _queue.first;

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;

  int get length => _queue.length;
  void clear() => _queue.clear();

  void sort() => _queue.sort(comparator);
  @override
  String toString() => _queue.toString();
}

/*
* Queue :
* import 'dart:collection';
* Queue<E> queue = new Queue<E>();
* */
