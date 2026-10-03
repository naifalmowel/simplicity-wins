import 'product.dart';

class CartItem {
  final Product product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  String get id => '${product.id}_${selectedSize}_$selectedColor';

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'productMap': product.toMap(),
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    final productMap = Map<String, dynamic>.from(map['productMap'] ?? {});
    final product = Product.fromMap(map['productId'] ?? '', productMap);
    return CartItem(
      product: product,
      selectedSize: map['selectedSize'] ?? 'M',
      selectedColor: map['selectedColor'] ?? 'أسود',
      quantity: map['quantity'] ?? 1,
    );
  }
}
