// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_lobby_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomLobbyStream)
final roomLobbyStreamProvider = RoomLobbyStreamFamily._();

final class RoomLobbyStreamProvider
    extends $FunctionalProvider<AsyncValue<Room?>, Room?, Stream<Room?>>
    with $FutureModifier<Room?>, $StreamProvider<Room?> {
  RoomLobbyStreamProvider._({
    required RoomLobbyStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomLobbyStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomLobbyStreamHash();

  @override
  String toString() {
    return r'roomLobbyStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Room?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Room?> create(Ref ref) {
    final argument = this.argument as String;
    return roomLobbyStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomLobbyStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomLobbyStreamHash() => r'72ff4a9d8a97519a8af45c61a80ce4abacc56c75';

final class RoomLobbyStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Room?>, String> {
  RoomLobbyStreamFamily._()
    : super(
        retry: null,
        name: r'roomLobbyStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomLobbyStreamProvider call(String roomId) =>
      RoomLobbyStreamProvider._(argument: roomId, from: this);

  @override
  String toString() => r'roomLobbyStreamProvider';
}

@ProviderFor(RoomLobbyController)
final roomLobbyControllerProvider = RoomLobbyControllerProvider._();

final class RoomLobbyControllerProvider
    extends $NotifierProvider<RoomLobbyController, bool> {
  RoomLobbyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomLobbyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomLobbyControllerHash();

  @$internal
  @override
  RoomLobbyController create() => RoomLobbyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$roomLobbyControllerHash() =>
    r'fecdfdde2a11ddfc43ba81012d1acc680ebaa5af';

abstract class _$RoomLobbyController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
