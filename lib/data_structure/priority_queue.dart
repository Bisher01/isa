import 'heap.dart';
import 'queue.dart';

export 'heap.dart' show Priority;

class PriorityQueue<E extends Comparable<dynamic>> implements Queue<E> {
  PriorityQueue({
    List<E>? elements,
    Priority priority = Priority.max,
  }) {
    _heap = Heap<E>(elements: elements, priority: priority);
  }

  late Heap<E> _heap;

  @override
  bool get isEmpty => _heap.isEmpty;

  @override
  E? get peek => _heap.peek;

  @override
  bool enqueue(E element) {
    _heap.insert(element);
    return true;
  }

  @override
  E? dequeue() => _heap.remove();
}

//
// //sort depending on weight
// class PriorityQueue {
//   List<WeightedLevel> queue = <WeightedLevel>[];
//   PriorityQueue();
//
//   enqueue(WeightedLevel value) {
//     queue.add(value);
//     queue.sort((a, b) {
//       return a.weight - b.weight;
//     });
//   }
//
//   dequeue() {
//     return queue.removeAt(0);
//   }
//
//   bool isEmpty() {
//     return queue.isEmpty;
//   }
//
//   bool notEmpty() {
//     return queue.isNotEmpty;
//   }
// }
//
// //Search, depending on heuristic value and weight
// class APriorityQueue {
//   List<HeroStickyLevel> queue = <HeroStickyLevel>[];
//   APriorityQueue();
//
//   enqueue(HeroStickyLevel value) {
//     queue.add(value);
//     queue.sort((a, b) {
//       return (a.weight+a.heroStickValue) - (b.weight+b.heroStickValue);
//     });
//   }
//
//   dequeue() {
//     return queue.removeAt(0);
//   }
//
//   bool isEmpty() {
//     return queue.isEmpty;
//   }
//
//   bool notEmpty() {
//     return queue.isNotEmpty;
//   }
// }
