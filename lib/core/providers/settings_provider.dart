import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provides the SharedPreferences instance synchronously
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

class SettingsState {
  final String themeId;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final double animationSpeed;

  const SettingsState({
    required this.themeId,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.animationSpeed,
  });

  SettingsState copyWith({
    String? themeId,
    bool? soundEnabled,
    bool? vibrationEnabled,
    double? animationSpeed,
  }) {
    return SettingsState(
      themeId: themeId ?? this.themeId,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationSpeed: animationSpeed ?? this.animationSpeed,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _themeKey = 'themeId';
  static const _soundKey = 'soundEnabled';
  static const _vibKey = 'vibrationEnabled';
  static const _animKey = 'animationSpeed';

  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    
    return SettingsState(
      themeId: _prefs.getString(_themeKey) ?? 'classic_casino',
      soundEnabled: _prefs.getBool(_soundKey) ?? true,
      vibrationEnabled: _prefs.getBool(_vibKey) ?? true,
      animationSpeed: _prefs.getDouble(_animKey) ?? 1.0,
    );
  }

  void setTheme(String themeId) {
    _prefs.setString(_themeKey, themeId);
    state = state.copyWith(themeId: themeId);
  }

  void toggleSound() {
    final newValue = !state.soundEnabled;
    _prefs.setBool(_soundKey, newValue);
    state = state.copyWith(soundEnabled: newValue);
  }

  void toggleVibration() {
    final newValue = !state.vibrationEnabled;
    _prefs.setBool(_vibKey, newValue);
    state = state.copyWith(vibrationEnabled: newValue);
  }

  void setAnimationSpeed(double speed) {
    _prefs.setDouble(_animKey, speed);
    state = state.copyWith(animationSpeed: speed);
  }
  
  void resetPreferences() {
    setTheme('classic_casino');
    if (!state.soundEnabled) toggleSound();
    if (!state.vibrationEnabled) toggleVibration();
    setAnimationSpeed(1.0);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
