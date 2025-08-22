import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

class AppSettings {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool notificationsEnabled;
  final double musicVolume;
  final double effectsVolume;

  const AppSettings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.notificationsEnabled = true,
    this.musicVolume = 0.7,
    this.effectsVolume = 0.8,
  });

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    double? musicVolume,
    double? effectsVolume,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      effectsVolume: effectsVolume ?? this.effectsVolume,
    );
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  void toggleVibration() {
    state = state.copyWith(vibrationEnabled: !state.vibrationEnabled);
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }

  void setMusicVolume(double volume) {
    state = state.copyWith(musicVolume: volume.clamp(0.0, 1.0));
  }

  void setEffectsVolume(double volume) {
    state = state.copyWith(effectsVolume: volume.clamp(0.0, 1.0));
  }
}
