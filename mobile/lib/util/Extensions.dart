extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension StringExtension on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;
}
