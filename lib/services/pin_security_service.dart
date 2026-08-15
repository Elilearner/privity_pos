import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

class PinHashResult {
  const PinHashResult({
    required this.hash,
    required this.salt,
    required this.version,
  });

  final String hash;
  final String salt;
  final int version;
}

class PinSecurityService {
  PinSecurityService._();

  static final PinSecurityService instance = PinSecurityService._();

  static const int currentHashVersion = 1;

  static const int _saltLength = 16;

  final Argon2id _argon2id = Argon2id(
    memory: 19 * 1024,
    parallelism: 1,
    iterations: 2,
    hashLength: 32,
  );

  bool isValidPinFormat(String pin) {
    final cleanPin = pin.trim();

    if (cleanPin.length < 6 || cleanPin.length > 8) {
      return false;
    }

    return RegExp(r'^[0-9]+$').hasMatch(cleanPin);
  }

  Future<PinHashResult> hashPin(String pin) async {
    final cleanPin = pin.trim();

    if (!isValidPinFormat(cleanPin)) {
      throw ArgumentError('El PIN debe contener entre 6 y 8 dígitos.');
    }

    final saltBytes = _generateSecureRandomBytes(_saltLength);

    final derivedKey = await _argon2id.deriveKeyFromPassword(
      password: cleanPin,
      nonce: saltBytes,
    );

    final hashBytes = await derivedKey.extractBytes();

    return PinHashResult(
      hash: base64Encode(hashBytes),
      salt: base64Encode(saltBytes),
      version: currentHashVersion,
    );
  }

  Future<bool> verifyPin({
    required String pin,
    required String storedHash,
    required String storedSalt,
    required int hashVersion,
  }) async {
    final cleanPin = pin.trim();

    if (!isValidPinFormat(cleanPin)) {
      return false;
    }

    if (hashVersion != currentHashVersion) {
      return false;
    }

    late final List<int> expectedHash;
    late final List<int> saltBytes;

    try {
      expectedHash = base64Decode(storedHash);

      saltBytes = base64Decode(storedSalt);
    } catch (_) {
      return false;
    }

    if (expectedHash.isEmpty || saltBytes.length != _saltLength) {
      return false;
    }

    final derivedKey = await _argon2id.deriveKeyFromPassword(
      password: cleanPin,
      nonce: saltBytes,
    );

    final actualHash = await derivedKey.extractBytes();

    return _constantTimeEquals(actualHash, expectedHash);
  }

  List<int> _generateSecureRandomBytes(int length) {
    final random = Random.secure();

    return List<int>.generate(
      length,
      (_) => random.nextInt(256),
      growable: false,
    );
  }

  bool _constantTimeEquals(List<int> first, List<int> second) {
    if (first.length != second.length) {
      return false;
    }

    var difference = 0;

    for (var index = 0; index < first.length; index++) {
      difference |= first[index] ^ second[index];
    }

    return difference == 0;
  }
}
