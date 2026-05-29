import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioService {
  void playSuspense() {
    debugPrint('AudioService: Playing Suspense Build-up');
    // TODO: implement with audioplayers
  }

  void playTruthWin() {
    debugPrint('AudioService: Playing Truth Win (Fail Challenge)');
  }

  void playLieWin() {
    debugPrint('AudioService: Playing Lie Win (Success Challenge)');
  }

  void playCardThrow() {
    debugPrint('AudioService: Playing Card Throw Sound');
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});
