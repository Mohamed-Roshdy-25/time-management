import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final GetStorage _storage = GetStorage();
  final String _key = 'isDark';

  cacheThemeToStorage(bool isDark) => _storage.write(_key, isDark);

  bool loadThemeFromStorage() => _storage.read(_key) ?? false;

  ThemeMode get theme =>
      loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;

  bool get switchTheme =>
      loadThemeFromStorage() ? true : false;

  void changeThemeMode() {
    Get.changeThemeMode(loadThemeFromStorage() ? ThemeMode.light : ThemeMode.dark);
    cacheThemeToStorage(!loadThemeFromStorage());
  }
}
