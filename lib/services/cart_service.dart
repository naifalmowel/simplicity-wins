import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoaded = false;

  List<CartItem> get items => _items;
  bool get isLoaded => _isLoaded;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

  CartService() {
    _loadCartFromStorage();
  }

  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('simplicity_wins_cart');
      if (cartString != null && cartString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(cartString);
        _items = jsonList.map((map) => CartItem.fromMap(Map<String, dynamic>.from(map))).toList();
      }
    } catch (e) {
      debugPrint('Cart loading error: $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _items.map((item) => item.toMap()).toList();
      await prefs.setString('simplicity_wins_cart', jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Cart saving error: $e');
    }
  }

  void addItem({
    required Product product,
    required String size,
    required String color,
    int quantity = 1,
  }) {
    if (!product.isAvailable || !product.isActive) return;

    final itemId = '${product.id}_${size}_$color';
    final existingIndex = _items.indexWhere((item) => item.id == itemId);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
        quantity: quantity,
      ));
    }

    _saveCartToStorage();
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _saveCartToStorage();
    notifyListeners();
  }

  void updateQuantity(String itemId, int delta) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCartToStorage();
    notifyListeners();
  }

  // Automatically filter out any out-of-stock or inactive products
  void validateCartWithLiveProducts(List<Product> liveProducts) {
    bool changed = false;
    _items.removeWhere((cartItem) {
      final liveProductIndex = liveProducts.indexWhere((p) => p.id == cartItem.product.id);
      if (liveProductIndex == -1) return false; // Not in live list yet, keep
      final liveProduct = liveProducts[liveProductIndex];
      final isInvalid = !liveProduct.isAvailable || !liveProduct.isActive;
      if (isInvalid) changed = true;
      return isInvalid;
    });

    if (changed) {
      _saveCartToStorage();
      notifyListeners();
    }
  }
}
