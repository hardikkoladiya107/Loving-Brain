import 'dart:convert';
import 'dart:typed_data';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInResult {
  final AuthorizationCredentialAppleID credential;
  final String rawNonce;

  const AppleSignInResult({
    required this.credential,
    required this.rawNonce,
  });
}

class AppleSignInManager {
  AppleSignInManager._internal();

  static final AppleSignInManager _instance = AppleSignInManager._internal();

  static AppleSignInManager get instance => _instance;

  Future<AppleSignInResult?> authenticateWithNonce() async {
    final bool available = await SignInWithApple.isAvailable();
    if (!available) {
      throw Exception(
        'Sign in with Apple is only available on iOS/macOS devices.',
      );
    }

    final String rawNonce = generateNonce();
    final String nonce = _sha256ofString(rawNonce);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      return AppleSignInResult(
        credential: credential,
        rawNonce: rawNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled ||
          e.code == AuthorizationErrorCode.unknown) {
        throw Exception('Apple Sign-In cancelled by the user (code=canceled)');
      }
      throw Exception('Apple Sign-In failed (${e.code.name}): ${e.message}');
    } on SignInWithAppleException catch (e) {
      throw Exception('Apple Sign-In failed: $e');
    }
  }

  Future<AuthorizationCredentialAppleID?> authenticate() async {
    final result = await authenticateWithNonce();
    return result?.credential;
  }

  static String _sha256ofString(String input) {
    final List<int> bytes = utf8.encode(input);
    final int bitLength = bytes.length * 8;

    final List<int> padded = List<int>.from(bytes)..add(0x80);
    while ((padded.length % 64) != 56) {
      padded.add(0);
    }
    final ByteData lenData = ByteData(8)..setUint64(0, bitLength, Endian.big);
    for (int i = 0; i < 8; i++) {
      padded.add(lenData.getUint8(i));
    }

    const List<int> k = <int>[
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
      0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
      0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
      0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
      0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
      0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
      0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
      0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
      0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    ];

    int h0 = 0x6a09e667;
    int h1 = 0x3bb67ae85 & 0xffffffff;
    h1 = 0xbb67ae85;
    int h2 = 0x3c6ef372;
    int h3 = 0xa54ff53a;
    int h4 = 0x510e527f;
    int h5 = 0x9b05688c;
    int h6 = 0x1f83d9ab;
    int h7 = 0x5be0cd19;

    int rotr(int x, int n) => ((x & 0xffffffff) >>> n) | ((x << (32 - n)) & 0xffffffff);

    final ByteData chunkData = ByteData.sublistView(Uint8List.fromList(padded));
    final List<int> w = List<int>.filled(64, 0);

    for (int offset = 0; offset < padded.length; offset += 64) {
      for (int i = 0; i < 16; i++) {
        w[i] = chunkData.getUint32(offset + i * 4, Endian.big);
      }
      for (int i = 16; i < 64; i++) {
        final int s0 = rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ ((w[i - 15] & 0xffffffff) >>> 3);
        final int s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ ((w[i - 2] & 0xffffffff) >>> 10);
        w[i] = (w[i - 16] + s0 + w[i - 7] + s1) & 0xffffffff;
      }

      int a = h0, b = h1, c = h2, d = h3, e = h4, f = h5, g = h6, h = h7;

      for (int i = 0; i < 64; i++) {
        final int s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
        final int ch = (e & f) ^ ((~e & 0xffffffff) & g);
        final int temp1 = (h + s1 + ch + k[i] + w[i]) & 0xffffffff;
        final int s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
        final int maj = (a & b) ^ (a & c) ^ (b & c);
        final int temp2 = (s0 + maj) & 0xffffffff;

        h = g;
        g = f;
        f = e;
        e = (d + temp1) & 0xffffffff;
        d = c;
        c = b;
        b = a;
        a = (temp1 + temp2) & 0xffffffff;
      }

      h0 = (h0 + a) & 0xffffffff;
      h1 = (h1 + b) & 0xffffffff;
      h2 = (h2 + c) & 0xffffffff;
      h3 = (h3 + d) & 0xffffffff;
      h4 = (h4 + e) & 0xffffffff;
      h5 = (h5 + f) & 0xffffffff;
      h6 = (h6 + g) & 0xffffffff;
      h7 = (h7 + h) & 0xffffffff;
    }

    final List<int> digest = <int>[h0, h1, h2, h3, h4, h5, h6, h7];
    final StringBuffer sb = StringBuffer();
    for (final int word in digest) {
      sb.write(word.toRadixString(16).padLeft(8, '0'));
    }
    return sb.toString();
  }
}
