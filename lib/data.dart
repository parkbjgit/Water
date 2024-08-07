import 'package:flutter/material.dart';

class Item {
  final IconData icon;
  final String name;
  final int price;
  bool purchased;
  int quantity;

  Item({
    required this.icon,
    required this.name,
    required this.price,
    this.purchased = false,
    this.quantity = 0,
  });
}

class ItemData extends ChangeNotifier {
  List<Item> _items = [
    Item(icon: Icons.grass, name: '씨앗', price: 10),  // 100 -> 10
    Item(icon: Icons.water_drop, name: '물', price: 30),  // 300 -> 30
    Item(icon: Icons.eco, name: '비료', price: 50),  // 500 -> 50
    Item(icon: Icons.local_florist, name: '영양제', price: 100),  // 1000 -> 100
    Item(icon: Icons.auto_awesome, name: '진화!', price: 1500),  // 1500 -> 150
  ];

  List<Item> get items => _items;

  void purchaseItem(int index) {
    if (_items[index].name == '씨앗') {
      _items[index].purchased = true;
    }
    _items[index].quantity++;
    notifyListeners();
  }

  void useItem(String itemName) {
    final item = _items.firstWhere((item) => item.name == itemName);
    if (item.quantity > 0) {
      item.quantity--;
      notifyListeners();
    }
  }
}
