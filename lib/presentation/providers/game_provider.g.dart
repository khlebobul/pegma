// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Game)
final gameProvider = GameFamily._();

final class GameProvider extends $NotifierProvider<Game, GameState> {
  GameProvider._({
    required GameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameHash();

  @override
  String toString() {
    return r'gameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Game create() => Game();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameHash() => r'67b0add8aa53b4aa6af3c2089014dc02eb4f6e64';

final class GameFamily extends $Family
    with $ClassFamilyOverride<Game, GameState, GameState, GameState, String> {
  GameFamily._()
    : super(
        retry: null,
        name: r'gameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameProvider call(String levelId) =>
      GameProvider._(argument: levelId, from: this);

  @override
  String toString() => r'gameProvider';
}

abstract class _$Game extends $Notifier<GameState> {
  late final _$args = ref.$arg as String;
  String get levelId => _$args;

  GameState build(String levelId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GameState, GameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameState, GameState>,
              GameState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
