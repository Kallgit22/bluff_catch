import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/transport/game_transport.dart';
import '../../domain/transport/local_game_transport.dart';

class GameTransportNotifier extends Notifier<GameTransport> {
  @override
  GameTransport build() {
    final transport = LocalGameTransport();
    
    ref.onDispose(() {
      state.dispose();
    });
    
    return transport;
  }

  void setTransport(GameTransport newTransport) {
    state = newTransport;
  }
}

final gameTransportProvider = NotifierProvider<GameTransportNotifier, GameTransport>(() {
  return GameTransportNotifier();
});
