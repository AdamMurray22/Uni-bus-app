import 'comparator.dart';

/// Performs a heap sort.
class HeapSort<E>
{
  final Comparator Function(E, E) _compare;
  final List<E> _heap = [];
  int _heapSize = 0;

  /// Constructor, assigns the comparator to be used.
  HeapSort(this._compare);

  /// Performs a heap sort on the given list using the comparator given in the
  /// constructor.
  List<E> sort(Iterable<E> iterable)
  {
    List<E> sortedList = [];
    for (E element in iterable)
    {
      _insert(element);
    }
    for (E element in iterable)
    {
      sortedList.add(_removeMin());
    }
    return sortedList;
  }

  // Insets a new element into the heap.
  _insert(E element)
  {
    _heap.insert(_heapSize, element);
    if (_heapSize == 0)
    {
      _heapSize++;
      return;
    }
    int currentIndex = _heapSize;
    int i = _heapSize;
    do
    {
      i = ((i - 1)/ 2).floor();
      if (_compare(element, _heap[i]) == Comparator.before)
      {
        _swap(currentIndex, i);
      }
      currentIndex = i;
    } while (i > 0);
    _heapSize++;
  }

  // Returns and removes the first element and adjusts the heap accordingly.
  E _removeMin()
  {
    _heapSize--;
    E min = _heap[0];
    _swap(0, _heapSize);
    _heap.removeAt(_heapSize);
    int currentIndex = 0;
    if (_heapSize == 0)
    {
      return min;
    }

    while (((2 * currentIndex) + 1 <= _heapSize - 1 &&
        _compare(_heap[currentIndex], _heap[(2 * currentIndex) + 1]) == Comparator.after) ||

        ((2 * currentIndex) + 2 <= _heapSize - 1 &&
            _compare(_heap[currentIndex], _heap[(2 * currentIndex) + 2]) == Comparator.after))
    {
      if ((2 * currentIndex) + 2 <= _heapSize - 1)
      {
        if ((2 * currentIndex) + 1 <= _heapSize - 1 && _compare(_heap[(2 * currentIndex) + 1], _heap[(2 * currentIndex) + 2]) == Comparator.before)
        {
          _swap(currentIndex, (2 * currentIndex) + 1);
          currentIndex = (2 * currentIndex) + 1;
        }
        else
        {
          _swap(currentIndex, (2 * currentIndex) + 2);
          currentIndex = (2 * currentIndex) + 2;
        }
      }
      else
      {
        _swap(currentIndex, (2 * currentIndex) + 1);
        currentIndex = (2 * currentIndex) + 1;
      }
    }
    return min;
  }

  // Swaps the elements at the given index's
  _swap(int index1, int index2)
  {
    E temp = _heap[index1];
    _heap[index1] = _heap[index2];
    _heap[index2] = temp;
  }
}