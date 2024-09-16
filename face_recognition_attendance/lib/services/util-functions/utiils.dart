class Utils {
  static String ordinal(int number) {
    if (!(number >= 1 && number <= 100)) {
      //here you change the range
      throw Exception('Invalid number');
    }

    if (number >= 11 && number <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}
