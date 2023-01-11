library threshold;

import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:lzstring/lzstring.dart';

String _lzstring({String? compress, String? decompress}) => decompress != null
    ? LZString.decompressFromBase64Sync(decompress)!
    : "!${LZString.compressToBase64Sync(compress ?? "error")!}";

String _bzip2({String? compress, String? decompress}) => decompress != null
    ? base64Encode(BZip2Decoder().decodeBytes(base64Decode(decompress)))
    : "@${base64Encode(BZip2Encoder().encode((compress ?? "error").codeUnits))}";

String _gzip({String? compress, String? decompress}) => decompress != null
    ? base64Encode(GZipDecoder().decodeBytes(base64Decode(decompress)))
    : "*${base64Encode(GZipEncoder().encode((compress ?? "error").codeUnits, level: 9)!)}";

String _zlib({String? compress, String? decompress}) => decompress != null
    ? base64Encode(const ZLibDecoder().decodeBytes(base64Decode(decompress)))
    : "^${base64Encode(const ZLibEncoder().encode((compress ?? "error").codeUnits, level: 9))}";

String debugCompress(String data) {
  Map<String, String?> all = {
    "RAW": data,
    "LZS": _attempt(() => _lzstring(compress: data)),
    "BZ2": _attempt(() => _bzip2(compress: data)),
    "GZI": _attempt(() => _gzip(compress: data)),
    "ZLI": _attempt(() => _zlib(compress: data)),
  };

  for (String key in all.keys) {
    print("$key: ${all[key]?.length ?? "-1"}: ${all[key] ?? "ERRORED"}");
  }

  print("   ");

  return compress(data);
}

String? _attempt(String Function() f) {
  try {
    return f();
  } catch (ignored) {
    return null;
  }
}

String compress(String data) =>
    [
      data,
      _attempt(() => _lzstring(compress: data)),
      _attempt(() => _bzip2(compress: data)),
      _attempt(() => _gzip(compress: data)),
      _attempt(() => _zlib(compress: data)),
    ]
        .where((element) => element != null)
        .reduce((a, b) => a!.length < b!.length ? a : b) ??
    "ERROR";

String decompress(String data) {
  if (data.substring(0, 1) == "!") {
    return _lzstring(decompress: data.substring(1));
  } else if (data.substring(0, 1) == "@") {
    return _bzip2(decompress: data.substring(1));
  } else if (data.substring(0, 1) == "*") {
    return _gzip(decompress: data.substring(1));
  } else if (data.substring(0, 1) == "^") {
    return _zlib(decompress: data.substring(1));
  } else {
    return data;
  }
}
