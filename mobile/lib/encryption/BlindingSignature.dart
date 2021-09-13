import 'dart:convert';
import 'dart:typed_data';

import 'package:mobile/exceptions/InvalidParametersException.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/utils.dart';

class BlindingSignature {
  static const int TRAILER_IMPLICIT = 0xBC;

  final Digest _contentDigest;
  final Digest _mgfDigest;
  // final AsymmetricBlockCipher _cipher;
  final int _hLen;
  final int _mgfhLen;
  final int _trailer;

  late bool _sSet;
  late int _sLen;
  late Uint8List _salt;
  late SecureRandom _random;

  late int _emBits;
  late Uint8List _block;
  late Uint8List _mDash;

  late bool _forSigning;

  late BigInt _blindingFactor;
  late AsymmetricKeyParameter<RSAAsymmetricKey> _kParam;
  late RSAEngine _core;

  BlindingSignature(this._contentDigest, this._mgfDigest, this._sLen,
      {int trailer = TRAILER_IMPLICIT})
      : _hLen = _contentDigest.digestSize,
        _mgfhLen = _mgfDigest.digestSize,
        _trailer = trailer;

}