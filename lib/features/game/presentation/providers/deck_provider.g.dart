// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeckNotifier)
final deckProvider = DeckNotifierProvider._();

final class DeckNotifierProvider
    extends $NotifierProvider<DeckNotifier, List<PlayingCard>> {
  DeckNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckNotifierHash();

  @$internal
  @override
  DeckNotifier create() => DeckNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PlayingCard> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PlayingCard>>(value),
    );
  }
}

String _$deckNotifierHash() => r'da316aa35d10738c8383b88fcaa3b128da760f7a';

abstract class _$DeckNotifier extends $Notifier<List<PlayingCard>> {
  List<PlayingCard> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<PlayingCard>, List<PlayingCard>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PlayingCard>, List<PlayingCard>>,
              List<PlayingCard>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
