import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

    // Add this to track selected items
  Set<int> _selectedItemIds = {};
  Set<int> get selectedItemIds => _selectedItemIds;

  int get total => _cart.fold(0, (sum, item) {
    int price = int.tryParse(item['sellPrice'] ?? '') ?? 0;
    int qty = item['qty'] ?? 0;
    return sum + price * qty;
  });




  void addItem(Map<String, dynamic> item) {
    _cart.add(item);
     _selectedItemIds.add(item['id']);
    notifyListeners();
  }

 void removeItemByName(String name) {
  // First find the item to get its ID
  final itemToRemove = _cart.firstWhere(
    (item) => item['name'] == name,
    orElse: () => {},
  );
  
  if (itemToRemove.isNotEmpty && itemToRemove.containsKey('id')) {
    // Remove from both cart and selected IDs
    _cart.removeWhere((item) => item['name'] == name);
    _selectedItemIds.remove(itemToRemove['id']);
    notifyListeners();
  }
}

  int indexOfByName(String name) {
    return _cart.indexWhere((item) => item['name'] == name);
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateQty(int index, int qty) {
    _cart[index]['qty'] = qty;
    notifyListeners();
  }

  void removeItem(int index) {
    _cart.removeAt(index);
    notifyListeners();
    
  }

   void setCart(List<Map<String, dynamic>> newCart) {
    _cart = newCart;
    notifyListeners();
  }


void updatePrice(int index, double price) {
  _cart[index]['sellPrice'] = price;
  notifyListeners();
}

}


