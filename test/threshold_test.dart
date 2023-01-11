import 'package:test/test.dart';
import 'package:threshold/threshold.dart';

void main() {
  List<String> comp = [
    "a",
    "Hello World",
    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  ];

  for (String i in comp) {
    test('Test Compression', () {
      expect(i, equals(decompress(compress(i))));
    });

    test('Test Compression LZS', () {
      expect(
          i,
          equals(compressZLib(
              decompress: compressZLib(compress: i).substring(1))));
    });

    test('Test Compression BZ2', () {
      expect(
          i,
          equals(compressBzip2(
              decompress: compressBzip2(compress: i).substring(1))));
    });

    test('Test Compression GZip', () {
      expect(
          i,
          equals(compressGzip(
              decompress: compressGzip(compress: i).substring(1))));
    });
  }
}
