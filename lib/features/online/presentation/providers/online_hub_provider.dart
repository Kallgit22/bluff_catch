import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/firebase_providers.dart';

part 'online_hub_provider.g.dart';

enum OnlineHubState {
  none,
  creating,
  created,
  joining,
  quickMatch,
}

@riverpod
class OnlineHub extends _$OnlineHub {
  String? generatedRoomCode;
  String? joinRoomError;

  @override
  OnlineHubState build() {
    return OnlineHubState.none;
  }

  Future<void> selectCreateRoom() async {
    if (state == OnlineHubState.creating) return;
    
    state = OnlineHubState.creating;
    joinRoomError = null;

    final functions = ref.read(functionsServiceProvider);
    final result = await functions.callFunction('createRoom');

    result.fold(
      (failure) {
        state = OnlineHubState.none;
        joinRoomError = failure.message;
      },
      (data) {
        final response = Map<String, dynamic>.from(data as Map);
        generatedRoomCode = response['roomId'] as String?;
        state = OnlineHubState.created;
      },
    );
  }

  void selectJoinRoom() {
    state = OnlineHubState.joining;
    generatedRoomCode = null;
    joinRoomError = null;
  }

  void selectQuickMatch() {
    state = OnlineHubState.quickMatch;
    generatedRoomCode = null;
    joinRoomError = null;
  }

  void reset() {
    state = OnlineHubState.none;
    generatedRoomCode = null;
    joinRoomError = null;
  }

  bool _isJoining = false;

  Future<bool> attemptJoinRoom(String code) async {
    if (_isJoining) return false;
    
    if (code.length < 6) {
      joinRoomError = 'Room code must be 6 characters.';
      state = OnlineHubState.joining;
      return false;
    }
    
    joinRoomError = null;
    _isJoining = true;
    // We can manually trigger a rebuild if we want, but local state in UI is better.
    
    final functions = ref.read(functionsServiceProvider);
    final normalizedCode = code.toUpperCase().trim();
    final result = await functions.callFunction('joinRoom', parameters: {'roomId': normalizedCode});

    _isJoining = false;
    return result.fold(
      (failure) {
        joinRoomError = failure.message;
        state = OnlineHubState.joining;
        return false;
      },
      (_) {
        joinRoomError = null;
        return true;
      },
    );
  }
}
