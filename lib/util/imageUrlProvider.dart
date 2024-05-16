import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUrlProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  static const String _imageUrlKey = 'imageUrl';

  String? _imageUrl;

  ImageUrlProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _imageUrl = _prefs.getString(_imageUrlKey);
    notifyListeners();
  }

  String? get imageUrl => _imageUrl;

  Future<void> setImageUrl(String url) async {
    _imageUrl = url;
    await _prefs.setString(_imageUrlKey, url);
    notifyListeners();
  }
}
