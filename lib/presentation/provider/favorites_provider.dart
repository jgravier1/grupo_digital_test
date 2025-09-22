import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grupo_digital_test/domain/entities/event_entity.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_events';
  
  List<EventEntity> _favoriteEvents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EventEntity> get favoriteEvents => List.unmodifiable(_favoriteEvents);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      _favoriteEvents = favoritesJson
          .map((jsonString) => EventEntity.fromJson(jsonDecode(jsonString)))
          .toList();
    } catch (e) {
      _errorMessage = 'Error al cargar favoritos: $e';
      if (kDebugMode) {
        print('Error loading favorites: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favoriteEvents
          .map((event) => jsonEncode(event.toJson()))
          .toList();
      
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      _errorMessage = 'Error al guardar favoritos: $e';
      if (kDebugMode) {
        print('Error saving favorites: $e');
      }
      notifyListeners();
    }
  }

  bool isFavorite(String eventId) {
    return _favoriteEvents.any((event) => event.id == eventId);
  }

  Future<void> toggleFavorite(EventEntity event) async {
    try {
      final existingIndex = _favoriteEvents.indexWhere((e) => e.id == event.id);
      
      if (existingIndex >= 0) {
        _favoriteEvents.removeAt(existingIndex);
      } else {
        _favoriteEvents.add(event);
      }
      
      notifyListeners();
      await _saveFavorites();
    } catch (e) {
      _errorMessage = 'Error al actualizar favoritos: $e';
      if (kDebugMode) {
        print('Error toggling favorite: $e');
      }
      notifyListeners();
    }
  }

  Future<void> addToFavorites(EventEntity event) async {
    if (!isFavorite(event.id)) {
      await toggleFavorite(event);
    }
  }

  Future<void> removeFromFavorites(String eventId) async {
    final event = _favoriteEvents.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found in favorites'),
    );
    await toggleFavorite(event);
  }

  Future<void> clearAllFavorites() async {
    _favoriteEvents.clear();
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }
}
