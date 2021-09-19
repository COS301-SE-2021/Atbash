import 'package:mobile/util/Utils.dart';
import 'package:test/test.dart';

void main() {
  group("Test cullToE164", () {
    test("spaces", () {
      expect(cullToE164("   1 2 3   "), "123");
    });

    test("punctuation", () {
      expect(cullToE164("-/1-2-3-/"), "123");
    });

    test("leading zeroes", () {
      expect(cullToE164("0000123000"), "123000");
    });
  });
}
