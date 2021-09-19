import 'package:test/test.dart';
import 'package:mobile/util/Extensions.dart';

void main() {
  group("Iterable.firstWhereOrNull", () {
    final testList = [1, 2, 3, 4, 5];
    test("Match exists", () {
      expect(testList.firstWhereOrNull((e) => e > 2), 3);
    });

    test("No match", () {
      expect(testList.firstWhereOrNull((e) => e > 6), null);
    });

    test("Empty list", () {
      expect(<int>[].firstWhereOrNull((e) => e > 1), null);
    });
  });

  group("String.isBlank", () {
    test("all spaces", () {
      final test = "    ";
      expect(test.isBlank, true);
    });

    test("all whitespace", () {
      final test = "\n\n\r";
      expect(test.isBlank, true);
    });

    test("empty string", () {
      final test = "";
      expect(test.isBlank, true);
    });

    test("non-whitespace characters", () {
      final test = "test";
      expect(test.isBlank, false);
    });
  });

  group("String.isNotBlank", () {
    test("all spaces", () {
      final test = "    ";
      expect(test.isNotBlank, false);
    });

    test("all whitespace", () {
      final test = "\n\n\r";
      expect(test.isNotBlank, false);
    });

    test("empty string", () {
      final test = "";
      expect(test.isNotBlank, false);
    });

    test("non-whitespace characters", () {
      final test = "test";
      expect(test.isNotBlank, true);
    });
  });
}
