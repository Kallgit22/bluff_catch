// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetupNotifier)
final setupProvider = SetupNotifierProvider._();

final class SetupNotifierProvider
    extends $NotifierProvider<SetupNotifier, SetupState> {
  SetupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupNotifierHash();

  @$internal
  @override
  SetupNotifier create() => SetupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetupState>(value),
    );
  }
}

String _$setupNotifierHash() => r'57ff5ec72a680d309e38824f8076ad3ea2e9d3d6';

abstract class _$SetupNotifier extends $Notifier<SetupState> {
  SetupState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SetupState, SetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SetupState, SetupState>,
              SetupState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
