import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/entities/event.dart';

class FavoritesRepository {
  static final FavoritesRepository instance = FavoritesRepository._();
  FavoritesRepository._();

  final String _key = 'favorite_events';
  List<Event> _favorites = [];

  List<Event> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    _favorites = data.map((e) => Event.fromJson(jsonDecode(e))).toList();
  }

  Future<void> addFavorite(Event event) async {
    _favorites.add(event);
    await _save();
  }

  Future<void> removeFavorite(Event event) async {
    _favorites.removeWhere((e) => e.type == event.type && e.datetime == event.datetime);
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _favorites.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, data);
  }

  bool isFavorite(Event event) {
    return _favorites.any((e) => e.type == event.type && e.datetime == event.datetime);
  }
}
