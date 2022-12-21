Threshold string compression with multiple GZip, LZString, ZLib, BZip2

## Features

Compression using all encoders and decoders from archive and lzstring. Finds the smallest output (including the input as a check) and uses that result. This method comes with several drawbacks

1. Compressed data starts with a unique NON-URL-SAFE character to indicate what algorithm was used.
2. Every time you call compress, you are using 4 different encoders which may not even be used if the text is short.

The goal is to get the smallest possible size, not to be efficient. So there is no defined character minimum to activate compression.

## Usage

```dart
import 'package:threshold/threshold.dart';

void main() {
  final compressed = compress('Hello World');
  final decompressed = decompress(compressed);
  print(decompressed); // Hello World
}
```
