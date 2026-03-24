import 'package:flutter/foundation.dart';
import 'package:formation_flutter/model/product.dart';

/// Singleton manager for favorite products.
/// No duplicates allowed (checked by barcode).
class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String barcode) {
    return _favorites.any((p) => p.barcode == barcode);
  }

  void addFavorite(Product product) {
    if (!isFavorite(product.barcode)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFavorite(String barcode) {
    _favorites.removeWhere((p) => p.barcode == barcode);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.barcode)) {
      removeFavorite(product.barcode);
    } else {
      addFavorite(product);
    }
  }
}
