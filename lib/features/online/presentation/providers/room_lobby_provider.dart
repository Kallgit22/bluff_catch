import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../game/domain/transport/firebase_game_transport.dart';
import '../../../game/presentation/providers/transport_provider.dart';
import '../../domain/room.dart';

part 'room_lobby_provider.g.dart';

@riverpod
Stream<Room?> roomLobbyStream(Ref ref, String roomId) {
  return FirebaseFirestore.instance
      .collection('rooms')
      .doc(roomId)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }
    return Room.fromJson(snapshot.data()!);
  });
}

@riverpod
class RoomLobbyController extends _$RoomLobbyController {
  @override
  bool build() => false;

  Future<String?> toggleLocalReady(String roomId) async {
    if (state) return null;
    state = true;
    final functions = ref.read(functionsServiceProvider);
    final res = await functions.callFunction('toggleReady', parameters: {'roomId': roomId});
    state = false;
    return res.fold((l) => l.message, (r) => null);
  }

  Future<String?> leaveRoom(String roomId) async {
    if (state) return null;
    state = true;
    final functions = ref.read(functionsServiceProvider);
    final res = await functions.callFunction('leaveMatch', parameters: {'roomId': roomId});
    state = false;
    return res.fold((l) => l.message, (r) => null);
  }

  Future<String?> startMatch(String roomId) async {
    if (state) return null;
    state = true;
    
    final functions = ref.read(functionsServiceProvider);
    final transportNotifier = ref.read(gameTransportProvider.notifier);
    
    final localPlayerId = FirebaseAuth.instance.currentUser?.uid;
    if (localPlayerId == null) {
      state = false;
      return 'User not logged in';
    }

    final createResult = await functions.callFunction('startMatch', parameters: {'matchId': roomId});
    
    state = false;
    return createResult.fold(
      (failure) => failure.message,
      (_) {
        final transport = FirebaseGameTransport(
          functionsService: functions,
          matchId: roomId,
          localPlayerId: localPlayerId,
        );
        transportNotifier.setTransport(transport);
        transport.connect();
        return null;
      },
    );
  }
}
