import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

// import 'package:mobile/exceptions/InvalidParametersException.dart';
// import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/utils.dart';

import 'package:crypto/crypto.dart';

class BlindSignatures {

  Uint8List messageToHash(String message) {
    final bytes = utf8.encode(message); // data being hashed
    final digest = sha256.convert(bytes);
    return digest.bytes as Uint8List;
  }

  BigInt messageToHashInt(String message) {
    final messageHash = messageToHash(message);
    BigInt messageBig = decodeBigIntWithSign(1, messageHash);
    return messageBig;
  }

  Map<String, Object> blind(String message, BigInt N, BigInt E ) {
    final messageHash = messageToHashInt(message);
    final bigN = BigInt.parse(N.toString());
    final bigE = BigInt.parse(E.toString());

    final bigOne = BigInt.parse('1');
    BigInt gcd;
    BigInt r;
    final sGen = Random.secure();
    do {
      r = decodeBigIntWithSign(1, Uint8List.fromList(List.generate(32, (_) => sGen.nextInt(255))));
      gcd = r.gcd(bigN);
    } while (
    gcd.compareTo(bigOne) != 0 ||
        r.compareTo(bigN) >= 0 ||
        r.compareTo(bigOne) <= 0
    );

    // now that we got an r that satisfies the restrictions described we can proceed with calculation of mu
    final mu = ((r.modPow(bigE, bigN)) * messageHash) % bigN; // Alice computes mu = H(msg) * r^e mod N
    return {
      "blinded": mu,
      "r": r,
    };
  }

  BigInt sign(BigInt blinded, BigInt bigN, BigInt bigP, BigInt bigQ, BigInt bigD) {
    // const { bigN, bigP, bigQ, bigD } = keyProperties(key);
    final mu = BigInt.parse(blinded.toString());

    // We split the mu^d modN in two , one mode p , one mode q
    final PinverseModQ = bigP.modInverse(bigQ); // calculate p inverse modulo q
    final QinverseModP = bigQ.modInverse(bigP); // calculate q inverse modulo p
    // We split the message mu in to messages m1, m2 one mod p, one mod q
    final m1 = (mu.modPow(bigD, bigN)) % (bigP); // calculate m1=(mu^d modN)modP
    final m2 = (mu.modPow(bigD, bigN)) % (bigQ); // calculate m2=(mu^d modN)modQ
    // We combine the calculated m1 and m2 in order to calculate muprime
    // We calculate muprime: (m1*Q*QinverseModP + m2*P*PinverseModQ) mod N where N =P*Q
    final muprime = ((m1 * bigQ * QinverseModP) + (m2 * bigP * PinverseModQ)) % bigN;

    return muprime;
  }

  BigInt unblind(BigInt signed, BigInt r, BigInt N) {
    final bigN = BigInt.parse(N.toString());
    final muprime = BigInt.parse(signed.toString());
    final s = (r.modInverse(bigN) * muprime) % bigN;// Alice computes sig = mu'*r^-1 mod N, inverse of r mod N multiplied with muprime mod N, to remove the blinding factor
    return s;
  }

  bool verify(BigInt unblinded, String message, BigInt E, BigInt N) {
    final signature = BigInt.parse(unblinded.toString());
    final messageHash = messageToHashInt(message);
    final bigN = BigInt.parse(N.toString());
    final bigE = BigInt.parse(E.toString());
    final signedMessageBigInt = signature.modPow(bigE, bigN);// calculate sig^e modN, if we get back the initial message that means that the signature is valid, this works because (m^d)^e modN = m
    final result = (messageHash.compareTo(signedMessageBigInt) == 0);
    return result;
  }

  bool verify2(BigInt unblinded, key, String message, BigInt D, BigInt N) {
    final signature = BigInt.parse(unblinded.toString());
    final messageHash = messageToHashInt(message);
    final bigN = BigInt.parse(N.toString());
    final bigD = BigInt.parse(D.toString());
    final msgSig = messageHash.modPow(bigD, bigN); // calculate H(msg)^d modN, if we get back the signature that means the message was signed
    final result = (signature.compareTo(msgSig) == 0);
    return result;
  }

  bool verifyBlinding(BigInt blinded, BigInt r, String unblinded, BigInt E, BigInt N) {
    final messageHash = messageToHashInt(unblinded);
    r = BigInt.parse(r.toString());
    N = BigInt.parse(N.toString());
    E = BigInt.parse(E.toString());

    final blindedHere = (messageHash * (r.modPow(E, N))) % N;
    final result = (blindedHere.compareTo(blinded) == 0);
    return result;
  }

}

