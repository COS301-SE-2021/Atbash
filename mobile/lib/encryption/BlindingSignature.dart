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

  void init(bool forSigning, RSAPublicKey key, BigInt blindingFactor){
    _sSet = false;
    _salt = Uint8List(_sLen);
    _mDash = Uint8List(8 + _sLen + _hLen);
    _forSigning = forSigning;
    _blindingFactor = blindingFactor;

    AsymmetricKeyParameter<RSAAsymmetricKey> kParam = PublicKeyParameter(key);
    _kParam = kParam;

    //--RSABlindingEngine.init
    _core = new RSAEngine();
    _core.init(_forSigning, kParam);
    //--RSABlindingEngine.init

    _emBits = kParam.key.modulus!.bitLength - 1;

    if (_emBits < (8 * _hLen + 8 * _sLen + 9))
    {
      throw new InvalidParametersException("key too small for specified hash and salt lengths");
    }

    _block = Uint8List((_emBits + 7) ~/ 8);

    _contentDigest.reset();
  }

  Uint8List generateSignature(String msg){
    Uint8List message = utf8.encode(msg) as Uint8List;

    _contentDigest.reset();
    _contentDigest.update(message, 0, message.length);
    _contentDigest.doFinal(_mDash, _mDash.length - _hLen - _sLen);

    if (_sLen != 0) {
      if (!_sSet) {
        _salt = _random.nextBytes(_sLen);
      }

      arrayCopy(_salt, 0, _mDash, _mDash.length - _sLen, _sLen);
    }

    var h = Uint8List(_hLen);

    _contentDigest.update(_mDash, 0, _mDash.length);

    _contentDigest.doFinal(h, 0);

    _block[_block.length - _sLen - 1 - _hLen - 1] = 0x01;
    arrayCopy(_salt, 0, _block, _block.length - _sLen - _hLen - 1, _sLen);

    var dbMask = _maskGeneratorFunction1(h, 0, h.length, _block.length - _hLen - 1);
    for (var i = 0; i != dbMask.length; i++) {
      _block[i] ^= dbMask[i];
    }

    arrayCopy(h, 0, _block, _block.length - _hLen - 1, _hLen);

    var firstByteMask = 0xff >> ((_block.length * 8) - _emBits);

    _block[0] &= firstByteMask;
    _block[_block.length - 1] = _trailer;

    var b = _cipher.process(_block);

    _clearBlock(_block);

    return PSSSignature(b);
  }

  /// Convert int to octet string.
  void _intToOSP(int i, Uint8List sp) {
    sp[0] = i >> 24;
    sp[1] = i >> 16;
    sp[2] = i >> 8;
    sp[3] = i >> 0;
  }





}