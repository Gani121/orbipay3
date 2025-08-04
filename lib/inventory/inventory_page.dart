import 'package:flutter/material.dart';
import 'add_item_page.dart';
import 'item_ledger_page.dart';
import 'dart:io';
import '../models/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/menu_item.dart';
import 'package:test1/cartprovier/ObjectBoxService.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  //final Store store;

  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final Box<MenuItem> _menuItemBox;
  List<MenuItem> _items = [];

  @override
  void initState() {
    super.initState();
    final store = Provider.of<ObjectBoxService>(context, listen: false).store;
    _menuItemBox = store.box<MenuItem>();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = _menuItemBox.getAll();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ObjectBoxService>(context, listen: false).store;
//final box = store.box<YourModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item List"),
        backgroundColor: Colors.purple.shade700,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: Text("INVENTORY (${_items.length})",
                              style: const TextStyle(color: Colors.purple)),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("CATEGORIES",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text("No items found. Add some items to get started!"),
            )
          : ListView.builder(
              itemCount: _items.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = _items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemLedgerPage(
                          item: item,
                          store: store,
                        ),
                      ),
                    ).then((_) => _loadItems()); // Refresh after returning
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          item.imagePath != null && item.imagePath!.isNotEmpty
                              ? Image.file(
                                  File(item.imagePath!),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image, color: Colors.grey),
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                Text("Barcode: ${item.barCode ?? 'N/A'}",
                                    style: const TextStyle(fontSize: 12)),
                                Text("₹ ${item.sellPrice}",
                                    style: const TextStyle(fontSize: 14)),
                                Text("Current Stock: ${item.adjustStock}",
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 6),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle adjust stock
                                  },
                                  child: const Text("Adjust Stock"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    minimumSize: const Size(100, 20),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddItemPage(store: store),
            ),
          );
          _loadItems(); // Refresh after adding new item
        },
        label: const Text("NEW ITEM"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.purple.shade700,
      ),
    );
  }
}