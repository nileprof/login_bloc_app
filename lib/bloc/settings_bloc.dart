import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsEvent {}

class LoadTheme extends SettingsEvent {}

class ToggleTheme extends SettingsEvent {}

class SettingsState {
  final bool isDarkMode;

  SettingsState({required this.isDarkMode});

  SettingsState copyWith({bool? isDarkMode}) {
    return SettingsState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(isDarkMode: false)) {
    // ✅ 1. سجل كل الـ events الأول
    on<LoadTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getBool('isDarkMode') ?? false;
      emit(SettingsState(isDarkMode: savedValue));
    });

    on<ToggleTheme>((event, emit) async {
      final newValue = !state.isDarkMode;
      emit(state.copyWith(isDarkMode: newValue));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', newValue);
    });

    // ✅ 2. بعد كده استدعي الحدث
    add(LoadTheme());
  }
}
