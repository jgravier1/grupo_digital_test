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

  /// Carga los favoritos desde SharedPreferences
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

  /// Guarda los favoritos en SharedPreferences
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

  /// Verifica si un evento es favorito
  bool isFavorite(String eventId) {
    return _favoriteEvents.any((event) => event.id == eventId);
  }

  /// Alterna el estado de favorito de un evento
  Future<void> toggleFavorite(EventEntity event) async {
    try {
      final existingIndex = _favoriteEvents.indexWhere((e) => e.id == event.id);
      
      if (existingIndex >= 0) {
        // Remover de favoritos
        _favoriteEvents.removeAt(existingIndex);
      } else {
        // Agregar a favoritos
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

  /// Agrega un evento a favoritos
  Future<void> addToFavorites(EventEntity event) async {
    if (!isFavorite(event.id)) {
      await toggleFavorite(event);
    }
  }

  /// Remueve un evento de favoritos
  Future<void> removeFromFavorites(String eventId) async {
    final event = _favoriteEvents.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found in favorites'),
    );
    await toggleFavorite(event);
  }

  /// Limpia todos los favoritos
  Future<void> clearAllFavorites() async {
    _favoriteEvents.clear();
    notifyListeners();
    await _saveFavorites();
  }

  /// Refresca los favoritos desde SharedPreferences
  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }
}
