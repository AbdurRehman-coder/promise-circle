class StringHasher {
  static const int _minThreshold = 5001;

  static int getDeterministicInt(String input) {
    int hash = 0;
    if (input.isNotEmpty) {
      for (int i = 0; i < input.length; i++) {
        int char = input.codeUnitAt(i);

        hash = (31 * hash + char) & 0xFFFFFFFF;
      }
    }

    final int positiveHash = hash & 0x7FFFFFFF;

    return positiveHash + _minThreshold;
  }
}
