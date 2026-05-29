// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameUINotifier)
final gameUIProvider = GameUINotifierProvider._();

final class GameUINotifierProvider
    extends $NotifierProvider<GameUINotifier, GameUIState> {
  GameUINotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameUIProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameUINotifierHash();

  @$internal
  @override
  GameUINotifier create() => GameUINotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameUIState>(value),
    );
  }
}

String _$gameUINotifierHash() => r'43c0558dd75bf97089b8d0016e545fe99e5ecf60';

abstract class _$GameUINotifier extends $Notifier<GameUIState> {
  GameUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameUIState, GameUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameUIState, GameUIState>,
              GameUIState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
