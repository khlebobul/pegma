// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LanguageNotifier)
const languageProvider = LanguageNotifierProvider._();

final class LanguageNotifierProvider
    extends $AsyncNotifierProvider<LanguageNotifier, ui.Locale> {
  const LanguageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageNotifierHash();

  @$internal
  @override
  LanguageNotifier create() => LanguageNotifier();
}

String _$languageNotifierHash() => r'3257b7c7718e2ba8aed8d44cbd8b314f3919cefe';

abstract class _$LanguageNotifier extends $AsyncNotifier<ui.Locale> {
  FutureOr<ui.Locale> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ui.Locale>, ui.Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ui.Locale>, ui.Locale>,
              AsyncValue<ui.Locale>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
