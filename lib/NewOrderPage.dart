import 'dart:ui' as BorderType;

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:test1/printer_setup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inventory/detailspage.dart';
import 'bill_printer.dart'; // Adjust the import path
import 'models/objectbox.g.dart';
import '../models/menu_item.dart';
import 'cartprovier/cart_provider.dart';
import 'package:provider/provider.dart';

import 'cartprovier/ObjectBoxService.dart';
import 'dart:convert';  // For jsonEncode/jsonDecode

import './inventory/add_item_page.dart';


final printer = BillPrinter();

bool isHoldEnabled = false;
String? selectedCategory;





// late final Store objectboxStore;


// final objectboxStore1 = objectboxStore.box<MenuItem>();





class NewOrderPage extends StatefulWidget {


  //final Store store;
  
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  _NewOrderPageState createState() => _NewOrderPageState();

}

class _NewOrderPageState extends State<NewOrderPage> {

  final ScrollController _scrollController = ScrollController();
final Map<String, GlobalKey> _categoryKeys = {};


  List<String> categories = [];
  //   "BEST SELLER ITEMS",
  //   "01 SNACKS",
  //   "02 MAINS",
  //   "03 RICE PREPARATION",
  //   "04 THALI",
  //   "05 VEG SOUP",
  //   "06 NON VEG SOUP",
  //   "07 RICE VEG",
  //   "08 NOODLES VEG",
  //   "10 NOODLES NON VEG",
  //   "11 STARTER VEG",
  //   "12 STARTER NON VEG",
  // ];

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  BluetoothDevice? selectedDevice;

  



  bool isGridView = true; // Add this as a state variable

  String selectedStyle = "Restaurant Style"; // default fallback

  
  Widget _buildGridView() {
  Map<String, List<Map<String, dynamic>>> groupedItems = {};
  for (var item in filteredItems) {
    String category = item["category"];
    groupedItems.putIfAbsent(category, () => []).add(item);
  }

  return ListView(
    controller: _scrollController,
    children: groupedItems.entries.map((entry) {
      final category = entry.key;
      final items = entry.value;

      return Column(
        key: _categoryKeys.putIfAbsent(category, () => GlobalKey()),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return _buildItemCard(items[index]);
            },
          ),
          Divider(color: Colors.blue.shade400, thickness: 1.5),
        ],
      );
    }).toList(),
  );
}


// Separate methods for cleaner code
// Widget _buildGridView() {
//   Map<String, List<Map<String, dynamic>>> groupedItems = {};
//   for (var item in filteredItems) {
//     String category = item["category"];
//     if (!groupedItems.containsKey(category)) {
//       groupedItems[category] = [];
//     }
//     groupedItems[category]!.add(item);
//   }

//   return ListView.builder(
//     controller: _scrollController, // Add scroll controller
//     itemCount: groupedItems.length,
//     itemBuilder: (context, categoryIndex) {
//       String category = groupedItems.keys.elementAt(categoryIndex);
//       List<Map<String, dynamic>> categoryItems = groupedItems[category]!;

//       return Column(
//         key: _categoryKeys[category], // Add key for scrolling
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: Text(
//               category,
//               style: TextStyle(
//                 fontSize: 16, 
//                 fontWeight: FontWeight.bold, 
//                 color: Colors.blue
//               ),
//             ),
//           ),
          
//           GridView.custom(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 6,
//               mainAxisSpacing: 6,
//               childAspectRatio: 1,
//             ),
//             childrenDelegate: SliverChildBuilderDelegate(
//               (context, index) => _buildItemCard(categoryItems[index]),
//               childCount: categoryItems.length,
//             ),
//           ),
//           Divider(color: Colors.blue.shade400, thickness: 1.5),
//         ],
//       );
//     },
//   );
// }



// Widget _imagebuildGridView() {
//   Map<String, List<Map<String, dynamic>>> groupedItems = {};
//   for (var item in filteredItems) {
//     String category = item["category"];
//     if (!groupedItems.containsKey(category)) {
//       groupedItems[category] = [];
//     }
//     groupedItems[category]!.add(item);
//   }

//   return ListView.builder(
//     controller: _scrollController,
//     itemCount: groupedItems.length,
//     itemBuilder: (context, categoryIndex) {
//       String category = groupedItems.keys.elementAt(categoryIndex);
//       List<Map<String, dynamic>> categoryItems = groupedItems[category]!;
      

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: Text(
//               category,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
//             ),
//           ),
          
//           GridView.custom(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 6,
//               mainAxisSpacing: 6,
//               childAspectRatio: 0.5, // Adjusted for image aspect ratio
//             ),
//             childrenDelegate: SliverChildBuilderDelegate(
//               (context, index) => _buildItemCardWithImage(categoryItems[index]),
//               childCount: categoryItems.length,
//             ),
//           ),
//           Divider(color: Colors.blue.shade400, thickness: 1.5),
//         ],
//       );
//     },
//   );
// }


Widget _imagebuildGridView() {
  Map<String, List<Map<String, dynamic>>> groupedItems = {};
  for (var item in filteredItems) {
    String category = item["category"];
    groupedItems.putIfAbsent(category, () => []).add(item);
  }

  return ListView(
    controller: _scrollController,
    children: groupedItems.entries.map((entry) {
      final category = entry.key;
      final items = entry.value;

      return Column(
        key: _categoryKeys.putIfAbsent(category, () => GlobalKey()),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 0.50,
            ),
            itemBuilder: (context, index) {
              return _buildItemCardWithImage(items[index]);
            },
          ),
          Divider(color: Colors.blue.shade400, thickness: 1.5),
        ],
      );
    }).toList(),
  );
}

Widget _buildItemCardWithImage(Map<String, dynamic> item) {
  return GestureDetector(
    onTap: () {
      setState(() {
        if (item['selected'] == true) {
          item['qty'] += 1;
        } else {
          item['selected'] = true;
          item['qty'] = 1;
        }
        updateCart(item);
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: item['selected'] == true ? Colors.green[100] : Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                height: 115,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  image: item['imageUrl'] != null
                      ? DecorationImage(
                          image: NetworkImage(item['imageUrl']),
                          fit: BoxFit.cover,
                        )
                      : null,
                  //color: item['imageUrl'] == null ? Colors.grey[200] : null,
                ),
                child: item['imageUrl'] == null
                    ? Center(child: Icon(Icons.image, color: Colors.grey))
                    : null,
              ),

              // Item Details
              Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPriceTag(item),
                        _buildQuantitySelector(item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Close button
          if (item['selected'] == true)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    item['selected'] = false;
                    item['qty'] = 0;
                    updateCart(item);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildListView() {
  Map<String, List<Map<String, dynamic>>> groupedItems = {};
  for (var item in filteredItems) {
    String category = item["category"];
    groupedItems.putIfAbsent(category, () => []).add(item);
  }

  return SingleChildScrollView(
    controller: _scrollController,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedItems.entries.map((entry) {
        String category = entry.key;
        List<Map<String, dynamic>> categoryItems = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            // Item List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: categoryItems.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: _buildItemCard(categoryItems[index], isList: true),
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Divider(color: Colors.blue.shade400, thickness: 1.5),
            ),
          ],
        );
      }).toList(),
    ),
  );
}

// Widget _buildItemCard(Map<String, dynamic> item, {bool isList = false}) {
//   return GestureDetector(
//     onTap: () {
//       setState(() {
//         if (item['selected'] == true) {
//           item['qty'] += 1; // increase qty
//         } else {
//           item['selected'] = true;
//           item['qty'] = 1;
//         }
//         updateCart(item);
//       });
//     },
//     child: Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: item['selected'] == true ? Colors.green[100] : Colors.white,
//             border: Border.all(color: Colors.black12),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           padding: EdgeInsets.all(isList ? 12 : 8),
//           child: isList ? _buildListItem(item) : _buildGridItem(item),
//         ),
        
//         // Close button - only visible when item is selected
//         if (item['selected'] == true)
//           Positioned(
//             top: 2,
//             right: 2,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   item['selected'] = false;
//                   item['qty'] = 0;
//                   updateCart(item);
//                 });
//               },
//               child: Container(
//                 padding: EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.close, size: 18, color: Colors.white),
//               ),
//             ),
//           ),
//       ],
//     ),
//   );
// }


Widget _buildGridItem(Map<String, dynamic> item) {
  return Column(
    children: [
      Flexible(
        child: Text(
          item["name"],
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.visible,
          maxLines: 3,
        ),
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuantitySelector(item),
          _buildPriceTag(item),
        ],
      ),
    ],
  );
}

Widget _buildListItem(Map<String, dynamic> item) {
  return Row(
    children: [
      Expanded(
        child: Text(
          item["name"],
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      _buildPriceTag(item),
      SizedBox(width: 12),
      _buildQuantitySelector(item),
    ],
  );
}



Widget _buildQuantitySelector(Map<String, dynamic> item) {
  return GestureDetector(
    onTap: () async {
      TextEditingController _controller = TextEditingController(
        text: (item['qty'] ?? 0).toString(),
      );

      final newQuantity = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Quantity"),
            content: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter quantity"),
              autofocus: true,
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(_controller.text),
              ),
            ],
          );
        },
      );

      if (newQuantity != null && newQuantity.isNotEmpty) {
        setState(() {
          item['qty'] = int.tryParse(newQuantity) ?? 0;
          item['selected'] = item['qty'] > 0; // Update selected state
          updateCart(item); // Update the cart with new quantity
        });
      }
    },
    child: Container(
      width: 30,
      height: 25,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        color: item['qty'] == 0 ? Colors.grey[200] : Colors.green[300],
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            (item['qty'] ?? 0).toString(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}



Widget _buildItemCard(Map<String, dynamic> item, {bool isList = false}) {
  return GestureDetector(
    onTap: () {
      setState(() {
        // Always increment quantity when item is tapped, whether selected or not
        item['qty'] = (item['qty'] ?? 0) + 1;
        item['selected'] = true; // Mark as selected
        updateCart(item);
      });
    },
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: item['selected'] == true ? Colors.green[100] : Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.all(isList ? 12 : 8),
          child: isList ? _buildListItem(item) : _buildGridItem(item),
        ),
        
        if (item['selected'] == true)
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  item['selected'] = false;
                  item['qty'] = 0;
                  updateCart(item);
                });
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
      ],
    ),
  );
}


// Widget _buildPriceTag(Map<String, dynamic> item) {
//   return DottedBorder(
//     color: Colors.black54,
//     strokeWidth: 1,
//     dashPattern: [4, 2],
//     radius: Radius.circular(4),
//     child: Container(
//       //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Text(
//         "${item["sellPrice"]}",
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// }


Widget _buildPriceTag(Map<String, dynamic> item) {
  return FutureBuilder<String?>(
    future: _getBillingType(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return SizedBox(); // or show a loading indicator
      }

      String billingType = snapshot.data!;
      String price = item["sellPrice"] ?? 0;

      if (billingType == "REGULAR") {
        price = item["sellPrice"] ?? 0;
      } else if (billingType == "AC") {
        price = item["acSellPrice"] ?? item["sellPrice"] ?? 0;
      } else if (billingType == "Non-Ac") {
        price = item["nonAcSellPrice"] ?? item["sellPrice"] ?? 0;
      }
      else if (billingType == "online-sale") {
        price = item["onlineSellPrice"] ?? item["sellPrice"] ?? 0;
      }
       else if (billingType == "online Delivery Price (parcel)") {
        price = item["onlineDeliveryPrice"] ?? item["sellPrice"] ?? 0;
      }

      return DottedBorder(
        color: Colors.black54,
        strokeWidth: 1,
        dashPattern: [4, 2],
        radius: Radius.circular(4),
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            "₹ ${price}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}

Future<String?> _getBillingType() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('selectedBillingType') ?? "REGULAR";
}




  Set<int> selectedIndexes = {};

   late final Box<MenuItem> _menuItemBox;

   bool isSearching= false;
   final TextEditingController _searchController = TextEditingController();


late final List<MenuItem> _items;

late final List<Map<String, dynamic>> items = _items.map((item) => item.toMap()).toList();
late List<Map<String, dynamic>> filteredItems=List.from(items); // Mutable filtered list

String _billingType = "";

  List<String> _extractCategories(List<MenuItem> items) {
    return items
        .map((item) => item.category)
        .toSet()
        .toList()
        ..sort();
  }


@override
void initState() {
  super.initState();
  loadSelectedStyle();
  final store = Provider.of<ObjectBoxService>(context, listen: false).store;
  _menuItemBox = store.box<MenuItem>();
 
  _loadSelectionState();
   _loadItems();
   _loadBillingType();
  
  // Add listener to cart changes
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  cartProvider.addListener(_handleCartChange);

  // Initialize category keys
  for (var category in categories) {
    _categoryKeys[category] = GlobalKey();
  }
}


void _loadBillingType() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _billingType = prefs.getString('selectedBillingType') ?? "REGULAR";
  });
}

void scrollToCategory(String category) async {
  final key = _categoryKeys[category];
  if (key == null || !_scrollController.hasClients) return;

  print("Initiating scroll to category: $category");

  // Step 1: Go to top
  await _scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: 10),
    curve: Curves.easeOut,
  );

  // Step 2: Start progressive downward scrolling
  final double step = 300.0;
  final double maxScroll = _scrollController.position.maxScrollExtent;
  double currentOffset = 0;

  for (int attempt = 0; attempt < 50; attempt++) {
    final context = key.currentContext;

    if (context != null) {
      print("Category $category is now visible — scrolling directly to it");
      Scrollable.ensureVisible(
        context,
        //duration: const Duration(milliseconds: 10),
        curve: Curves.easeInOut,
        alignment: 0,
      );
      return;
    }

    // Scroll down step-by-step
    currentOffset += step;
    if (currentOffset > maxScroll) break;

    await _scrollController.animateTo(
      currentOffset,
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );

    await Future.delayed(const Duration(milliseconds: 100));
  }

  print("Failed to locate category $category after scrolling");
}

Future<void> _loadSelectionState() async {
  final prefs = await SharedPreferences.getInstance();
  final selectedItems = prefs.getStringList('selectedItems') ?? [];

  setState(() {
    for (var item in items) {
      // Find matching entry in SharedPreferences
      final savedItem = selectedItems.firstWhere(
        (entry) {
          final decoded = jsonDecode(entry);
          return decoded['id'] == item['id'];
        },
        orElse: () => '{}',
      );

      if (savedItem != '{}') {
        final decoded = jsonDecode(savedItem);
        item['selected'] = true;
        item['qty'] = decoded['qty'] ?? 1; // Default to 1 if missing
      } else {
        item['selected'] = false;
        item['qty'] = 0;
      }
    }
  });
}

  Future<void> _loadItems() async {
    final store = Provider.of<ObjectBoxService>(context, listen: false).store;
    final items = store.box<MenuItem>().getAll();
    setState(() {
      _items = items.map((item) => item.copyWith(selected: false, qty: 0)).toList();
    });
     categories = _extractCategories(_items);

     //filteredItems = List.from(items); // Copy for filtering
  }


void _handleCartChange() {

  if (!mounted) return; // Ensure widget is still mounted

  final cartProvider = Provider.of<CartProvider>(context, listen: false);

  
  if (cartProvider.cart.isEmpty) {
    if (mounted) {
      setState(() {
        for (var item in items) {
          item['selected'] = false;
          item['qty'] = 0;
        }
      });
    }
  } else {
    if (mounted) {
      setState(() {
        final cartItemIds = cartProvider.cart.map((e) => e['id']).toList();
        for (var item in items) {
          final isInCart = cartItemIds.contains(item['id']);
          item['selected'] = isInCart;
          if (isInCart) {
            final cartItem = cartProvider.cart.firstWhere(
              (e) => e['id'] == item['id'],
              orElse: () => {'qty': 0},
            );
            item['qty'] = cartItem['qty'] ?? 0;
          } else {
            item['qty'] = 0;
          }
        }
      });
    }
  }
}

Future<void> loadSelectedStyle() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    selectedStyle = prefs.getString('selectedStyle') ?? "Restaurant Style";
  });
}
  
  
  void showPrintOptions(BuildContext context) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);;
    final cart = cartProvider.cart;
    final store = Provider.of<ObjectBoxService>(context, listen: false).store;


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🧾 Choose Action"),
        content: Text("Would you like to print or print & settle the bill?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final total = await getTotal(); // 👈 Await the total
              print(total);
              await printer.printCart(
                 context: context,
                  cart1: cart,
                  total: total,
                  mode: "print",
                  //Store:store,
              );
            },
            child: Text("PRINT"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final total = await getTotal(); // 👈 Await the total
            print(total);
              // TODO: Implement print & settle logic
              await printer.printCart(
                 context: context,
                  cart1: cart,
                  total: total,
                  mode: "settle",
                  //Store: widget.store
              );

              print("Printing & Settling...");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text("PRINT & SETTLE"),
          ),
        ],
      ),
    );
  }


void updateCart(Map<String, dynamic> item) async {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final prefs = await SharedPreferences.getInstance();
  List<String> selectedItems = prefs.getStringList('selectedItems') ?? [];

  // Update SharedPreferences
  if (item['selected']) {
    final itemJson = jsonEncode({
      'id': item['id'],
      'qty': item['qty'],
    });
    
    // Remove old entry if exists
    selectedItems.removeWhere((entry) {
      final decoded = jsonDecode(entry);
      return decoded['id'] == item['id'];
    });
    
    selectedItems.add(itemJson);
  } else {
    selectedItems.removeWhere((entry) {
      final decoded = jsonDecode(entry);
      return decoded['id'] == item['id'];
    });
  }
  await prefs.setStringList('selectedItems', selectedItems);

  // Update CartProvider
  if (item['selected'] == true) {
    final existingIndex = cartProvider.indexOfByName(item['name']);
    if (existingIndex == -1) {
      cartProvider.addItem({...item}); // Add new item with spread operator
    } else {
      cartProvider.updateQty(existingIndex, item['qty']); // Update with current qty
    }
  } else {
    cartProvider.removeItemByName(item['name']);
  }

  // Update UI state
  setState(() {
    // Ensure qty is never null
    item['qty'] = item['qty'] ?? 0;
    
    // Clear all highlights if cart is empty
    if (cartProvider.cart.isEmpty) {
      for (var menuItem in items) {
        menuItem['selected'] = false;
        menuItem['qty'] = 0;
      }
    }
  });
}
 
  void showCartItems() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);;
    final cart = cartProvider.cart;
    print("BILL RECEIPT ITEMS:");
    for (var item in cart) {
      print("${item['name']} x ${item['qty']} @ ₹${item['sellPrice']} = ₹${item['qty'] * item['sellPrice']}");
    }
  }

  // int getTotal() {
  //       final cartProvider = Provider.of<CartProvider>(context, listen: false);;
  //   final cart = cartProvider.cart;
  //   int total = 0;
  //   if (cart == null) return total; // if cart is nullable

  //   for (var item in cart) {
  //     final qty = item['qty'] ?? 0;
  //     final price = item['sellPrice'] ?? 0;
  //     total += (qty is int ? qty : int.tryParse(qty.toString()) ?? 0) *
  //         (price is int ? price : int.tryParse(price.toString()) ?? 0);
  //   }
  //   return total;
  // }

int getTotal() {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final cart = cartProvider.cart;
  int total = 0;

  for (var item in cart) {
    final qty = item['qty'] ?? 0;

    // Convert price string to int safely
    int parsePrice(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int price = 0;

    print("_billingType $_billingType");


    if (_billingType == "REGULAR") {
      price = parsePrice(item["sellPrice"]);
    } else if (_billingType == "AC") {
      price = parsePrice(item["acSellPrice"]) != 0
          ? parsePrice(item["acSellPrice"])
          : parsePrice(item["sellPrice"]);
    } else if (_billingType == "Non-Ac") {
      price = parsePrice(item["nonAcSellPrice"]) != 0
          ? parsePrice(item["nonAcSellPrice"])
          : parsePrice(item["sellPrice"]);
    } else if (_billingType == "online-sale") {
      price = parsePrice(item["onlineSellPrice"]) != 0
          ? parsePrice(item["onlineSellPrice"])
          : parsePrice(item["sellPrice"]);
    } else if (_billingType == "online Delivery Price (parcel)") {
      price = parsePrice(item["onlineDeliveryPrice"]) != 0
          ? parsePrice(item["onlineDeliveryPrice"])
          : parsePrice(item["sellPrice"]);
    }

    total += (qty is int ? qty : int.tryParse(qty.toString()) ?? 0) * price;
  }

  print("total-------$total");
  return total;
}

  void showCartDialog(BuildContext context) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);;
    final cart = cartProvider.cart;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("🧾 Bill Receipt"),
          content: cart.isEmpty
              ? Text("No items selected.")
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text("Item",
                          style: TextStyle(
                              fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Center(
                          child: Text("Qty",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold)))),
                  Text("Amount",
                      style:
                      TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(),

              // Cart Items
              ...cart.map((item) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("${item['name']}")),
                  Expanded(
                      child: Center(
                          child: Text("x${item['qty']}"))),
                  Text("₹${item['qty'] * item['sellPrice']}"),
                ],
              )),

              Divider(),

              // Total Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("₹${getTotal()}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);;
    final cart = cartProvider.cart;

    int total = getTotal(); 

    if (cart.isEmpty) {
      setState(() {
        selectedIndexes.clear();
      });
    }


    Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in items) {
      String category = item["category"];
      if (!groupedItems.containsKey(category)) {
        groupedItems[category] = [];
      }
      groupedItems[category]!.add(item);
    }
    return Scaffold(
 appBar: AppBar(
        title: Row(
          children: [
            Text("Select Items"),
            const SizedBox(width: 8),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 10),
                curve: Curves.easeInOut,
                height: 40,
                width: isSearching ? double.infinity : 0,
                child: isSearching
                    ? TextField(
                        //controller: _searchController,
                        autofocus: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.blue[700],
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                       onChanged: (query) {
                          setState(() {
                            filteredItems = items.where((item) {
                              final name = item['name'].toString().toLowerCase();
                              return name.contains(query.toLowerCase());
                            }).toList();
                          });
                        },

                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) _searchController.clear();
                isSearching = !isSearching;
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // Left Category Panel
                Container(
                  width: 100,
                  height: constraints.maxHeight,
                  color: Colors.grey[350],

                  child: Column(
                    children: [
                      //white space
                      SizedBox(height: 60),
                      // ListView below
                      Expanded(
                  child: ListView.builder(
  itemCount: categories.length,
  itemBuilder: (context, index) {
    final category = categories[index];
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        scrollToCategory(category);
      },
      child: Container(
        margin: EdgeInsets.all(2),
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[300] : Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  },
),

                ),
                ],
                  ),
                ),



                // Right side Grid
                Expanded(

                  child: Column(
                    children: [
                      // Top grey patch (T-head) with square buttons
                      Container(
                        width: double.infinity,
                        color: Colors.grey[350], // Flat grey background
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        //margin: EdgeInsets.only(bottom: 8), // Space before GridView
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                           _buildFlatSquareButton(Icons.add, "Items", () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AddItemPage(), // Replace with your actual page
                            //   ),
                            // );
                          }),

                           
                          _buildFlatSquareButton(
                              Icons.edit,
                              "HOLD",
                              () async {
                              setState(() {
                                isHoldEnabled = !isHoldEnabled;
                              });

                              final prefs = await SharedPreferences.getInstance();
                              prefs.setBool('isHoldEnabled', isHoldEnabled);
                            },

                              isActive: isHoldEnabled,
                                                        
                           
                            ),



                            _buildFlatSquareButton(Icons.local_shipping, "PARCEL", () {
                              // Do something
                            }),
                          ],
                        ),
                      ),
                      // Item grid below
                      Expanded(
                        child: Container(
                          color: Colors.grey[200],

                          child: selectedStyle == "Restaurant Style"
                          ? _buildGridView()
                          : selectedStyle == "List Style"
                              ? _buildListView()
                              : selectedStyle == "Restaurant With Image Style"
                                  ? _imagebuildGridView()
                                  : _buildGridView(), // fallback if none match


                
                        ),
                      ),


                    ],
                  ),
                ),


              ],
            );
          },
        ),

      ),



      // Bottom Bar
      bottomNavigationBar: BottomAppBar(
        
        color: Colors.grey[300],
        elevation: 0, // Optional: remove shadow
        child: SizedBox(
          height: 60, // Exact height of buttons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // DETAILS Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle DETAILS
                    //showCartDialog(context);
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                       
                      builder: (context) => DetailPage(
                        //objectBox:widget.store, // 🔁 Pass the Store here
                      ),
                    ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Touch bottom
                    ),
                  ),
                  child: const Text("DETAILS", style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(width: 8),

              // KOT Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle KOT
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("KOT", style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(width: 8),

              // SAVE Button (disabled)
              Expanded(

    child:  ElevatedButton(
        onPressed: () => showPrintOptions(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "SAVE (₹ $total)",
          
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),

    
              ),



            ],
          ),
        ),
      ),

    );
  }



 
  }






Widget _buildFlatSquareButton(
    IconData icon, String label, VoidCallback onPressed,
    {bool isActive = false}) {
  return Container(
    color: isActive ? Colors.green : Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}



