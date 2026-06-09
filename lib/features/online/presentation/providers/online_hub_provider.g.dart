// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_hub_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnlineHub)
final onlineHubProvider = OnlineHubProvider._();

final class OnlineHubProvider
    extends $NotifierProvider<OnlineHub, OnlineHubState> {
  OnlineHubProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onlineHubProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onlineHubHash();

  @$internal
  @override
  OnlineHub create() => OnlineHub();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnlineHubState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnlineHubState>(value),
    );
  }
}

String _$onlineHubHash() => r'50eabdb41adc177a9ff38b6cdfbe7183d8702e56';

abstract class _$OnlineHub extends $Notifier<OnlineHubState> {
  OnlineHubState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OnlineHubState, OnlineHubState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnlineHubState, OnlineHubState>,
              OnlineHubState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
