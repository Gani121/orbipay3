import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'NewOrderPage.dart';
import 'SettingsPage.dart';
import 'inventory/inventory_page.dart';
import 'models/objectbox.g.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import'./cartprovier/cart_provider.dart';
import'./cartprovier/ObjectBoxService.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/transaction.dart';
import 'bill_printer.dart'; // Adjust the import path

import 'inventory/detailspage.dart';

import './pages/PartyListPage.dart';

import './theme_setting/theme_provider.dart';
//import './theme_setting/settings_page.dart'; // <- settings screen


// late final Store objectboxStore;

// Future<Store> openObjectBoxStore() async {
//   final dir = await getApplicationDocumentsDirectory();
//   return Store(getObjectBoxModel(), directory: '${dir.path}/objectbox');
// }

    final printer = BillPrinter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final objectBoxService = ObjectBoxService();
  await objectBoxService.init();


  // final dir = await getApplicationDocumentsDirectory();
  // objectboxStore = Store(getObjectBoxModel(), directory: '${dir.path}/objectbox');

  //await deleteOldObjectBoxStore(); // 👈 Run this ONCE to clean the store
  //objectboxStore = await openStore(); // or Store(getObjectBoxModel())
 runApp(
    MultiProvider(
      providers: [
        Provider<ObjectBoxService>.value(value: objectBoxService),
        ChangeNotifierProvider(create: (_) => CartProvider()),
       ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      
    ),
        // Add more providers if needed
      ],
      child: MyApp(),
    ),
  );
}


Future<void> deleteOldObjectBoxStore() async {
  final dir = await getApplicationDocumentsDirectory(); // <- await is important
  final objectboxDir = Directory('${dir.path}/objectbox');
  if (await objectboxDir.exists()) {
    print("Deleting old ObjectBox store...");
    await objectboxDir.delete(recursive: true);
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Test',
      theme: ThemeData(primarySwatch: Colors.red),
      home: DostiKitchenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}



class DostiKitchenPage extends StatefulWidget {
  @override
  _DostiKitchenPageState createState() => _DostiKitchenPageState();
}






class _DostiKitchenPageState extends State<DostiKitchenPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  BluetoothDevice? selectedDevice;

  List<Map<String, dynamic>> transactions = [];


  @override
  void dispose() {
    Provider.of<ObjectBoxService>(context, listen: false).dispose();
    super.dispose();
  }
late Store store;
  @override
  void initState() {
    super.initState();
    store = Provider.of<ObjectBoxService>(context, listen: false).store;
    // 🔄 Set the callback to reload data when a new transaction is added

    printer.onTransactionAdded = () {
       print("loadRecentTransactions calle");
      loadRecentTransactions(store);
    };
    loadRecentTransactions(store);
  }


  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  store = Provider.of<ObjectBoxService>(context, listen: false).store;
  loadRecentTransactions(store);
}


void _loadHoldStatus() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    isHoldEnabled = prefs.getBool('isHoldEnabled') ?? false;
  });
}

Future<void> loadRecentTransactions(Store store) async {
  final box = store.box<Transaction>();
  final all = box.getAll();

WidgetsBinding.instance.addPostFrameCallback((_) async {
  final prefs = await SharedPreferences.getInstance();
  final isHoldEnabled = prefs.getBool('isHoldEnabled') ?? false;

  if (!isHoldEnabled) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.clearCart();
    await prefs.remove('selectedItems'); 
  }


});


  // Optional: Sort by latest
 // all.sort((a, b) => b.time.compareTo(a.time));
print('Loaded ${all.length} transactions');
  // Update your state with decoded transactions
  setState(() {
    transactions = all
        .map((tx) => {
              'id': tx.id,
              //'time': tx.time,
              'tableNo': tx.tableNo,
              'total': tx.total,
              'cart': jsonDecode(tx.cartData),
            })
        .toList();
        print('setState called with ${transactions.length} transactions');
  });
}


  int getTodayTotalSale() {
    return transactions.fold(0, (sum, tx) => sum + (tx['total'] as int? ?? 0));
  }



  // final List<Map<String, String>> transactions = [
  //   {'sale': '₹ 3170', 'moneyIn': '₹ 3170', 'id': '19571'},
  //   {'sale': '₹ 240', 'moneyIn': '₹ 240', 'id': '19570'},
  //   {'sale': '₹ 130', 'moneyIn': '₹ 130', 'id': '19669'},
  //   {'sale': '₹ 550', 'moneyIn': '₹ 550', 'id': '19568'},
  //   {'sale': '₹ 750', 'moneyIn': '₹ 750', 'id': '19567'},
  // ];

  String formatDateTime(String isoTime) {
    final dt = DateTime.tryParse(isoTime);
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }


  List<Map<String, dynamic>> activeTables = [
    {
      'number': 1,
      'total': 450,
      'orders': [
        {'name': 'Paneer Butter Masala', 'qty': 2, 'price': 150},
        {'name': 'Butter Naan', 'qty': 3, 'price': 50},
        {'name': 'Paneer Butter Masala', 'qty': 2, 'price': 150},
        {'name': 'Butter Naan', 'qty': 3, 'price': 50},
        {'name': 'Paneer Butter Masala', 'qty': 2, 'price': 150},
        {'name': 'Butter Naan', 'qty': 3, 'price': 50},
        {'name': 'Paneer Butter Masala', 'qty': 2, 'price': 150},
        {'name': 'Butter Naan', 'qty': 3, 'price': 50},
        {'name': 'Paneer Butter Masala', 'qty': 2, 'price': 150},
        {'name': 'Butter Naan', 'qty': 3, 'price': 50},
      ]
    },
    {
      'number': 2,
      'total': 300,
      'orders': [
        {'name': 'Veg Biryani', 'qty': 2, 'price': 150},
      ]
    },
  ];

  //get table => null;


  Widget buildChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      key: _scaffoldKey,



    // 🔹 Left Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 260, // ⬆️ Increased height
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue.shade600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Text(
                        'D', // Initial
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Dosti Kitchen',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+91 9876543210',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            // Add other drawer items below here...

            ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard'), onTap: () {}),
            ListTile(leading: Icon(Icons.inventory), title: Text('Inventory'), onTap: () {}),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings'), onTap: () {}),
            ListTile(leading: Icon(Icons.person), title: Text('Profile'), onTap: () {}),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout'), onTap: () {}),
          ],
        ),
      ),

      // 🔹 Right Drawer
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.green.shade600),
                child: Center(
                  child: Text(
                    'Active Tables',
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            ...activeTables.map((table) => ExpansionTile(
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade700, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Table ${table['number']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                    Text(
                      '₹${table['total']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
              ),

              children: [
                ...table['orders'].map<Widget>((item) => ListTile(
                  title: Text('${item['name']}'),
                  subtitle: Text('Qty: ${item['qty']} x ₹${item['price']}'),
                  trailing: Text('₹${item['qty'] * item['price']}'),
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                      onPressed: () async {
                      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();

                      if (devices.isNotEmpty) {
                      _showDevicePickerDialog(context, devices);

                      } else {
                      print("⚠️ No paired devices found.");
                      }
                      await bluetooth.disconnect();
                      },


                        icon: Icon(Icons.print),
                        label: Text('Print'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle settle logic
                          print('✅ Settling Table ${table['number']}');
                        },
                        icon: Icon(Icons.check_circle_outline),
                        label: Text('Settle'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            )),
          ],
        ),
      ),


      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        elevation: 0,

        // 🔹 Left Menu Button
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),

        

        title: Row(
          children: [
            Icon(Icons.restaurant, size: 24, color: Colors.white),
            SizedBox(width: 8),
            Text('Dosti Kitchen', style: TextStyle(color: Colors.white)),
            Spacer(),

            // 🔹 Right Menu Button
            // IconButton(
            //   onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            //   icon: Text(
            //     '🪑',
            //     style: TextStyle(fontSize: 40),
            //   ),
            // ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Container(
            padding: EdgeInsets.all(4),
            alignment: Alignment.centerLeft,
            color: Colors.lightGreenAccent.shade700,
            child: Text(
              DateFormat('dd/MM/yy hh:mm:ss a').format(DateTime.now()),
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),

    ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(child: _infoCard('📊Reports', 'Check Reports')),
                SizedBox(width: 10),
                Expanded(
                  child: _infoCard('💰 Sale (TODAY)', '₹ ${getTodayTotalSale()}'),
                ),

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _infoCard(
                    '🏆 G Score',
                    '50',
                    //icon: Icon(Icons., size: 14, color: Colors.grey.shade700),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: _infoCard('⏳Reply Pending', '0 / 41')),
                SizedBox(width: 10),
                Expanded(child: _infoCard('⭐Review', '41')),
              ],

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Data Upload Pending!\n2198 records need to be uploaded.',
                style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'RECENT SALE TRANSACTIONS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var tx = transactions[index];
                return GestureDetector(
                onTap: () {
                  _showTransactionOptionsDialog(context, tx);
                },
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Date & ID Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   //formatDateTime(tx['time']), // format ISO time
                            //   //style: TextStyle(fontSize: 12, color: Colors.black),
                            // ),
                            Text(
                              'Table: ${tx['tableNo'] ?? "-"}',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // 🔹 Box with Cash Sale & Sale Amount
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cash Sale',
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.bold)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Sale: ₹${tx['total']}',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Items: ${tx['cart'].length}',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),

                        // 🔹 Chips row (disabled for now)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // You can show payment method if saved
                            // buildChip(tx['method'] ?? 'CASH'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                );
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewOrderPage()),
          ).then((_) {
  loadRecentTransactions(store);
});
        },
        label: Text('New Order'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });


           if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PartyListPage()),
            );
          }
          if (index == 2) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => InventoryPage()),
            // );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryPage()),
            );
          }
          else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Party"),
          BottomNavigationBarItem(icon: Icon(Icons.balance), label: "Udhari"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );

  }


  //   void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });

  //   // Navigate to PartyListPage on Inventory tab click (index 1)
  //   if (index == 1) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => PartyListPage()),
  //     );
  //   }
  // }

  Widget _infoCard(String title, String value, {Widget? icon}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) icon,
              if (icon != null) SizedBox(width: 4),
              Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            ],
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Map<String, dynamic> table = {
    "number": 5,
    "total": 270,
    "orders": [
      {
        "name": "Veg Burger",
        "qty": 2,
        "price": 60
      },
      {
        "name": "French Fries",
        "qty": 1,
        "price": 50
      },
      {
        "name": "Coke",
        "qty": 2,
        "price": 50
      }
    ]
  };


  void _showTransactionOptionsDialog(BuildContext context, Map<String, dynamic> tx) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Transaction: Table ${tx['tableNo']}'),
      content: Text('Choose an action for this transaction.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close dialog
            _printTransaction(tx);
          },
          child: Text('🖨️ Print'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close dialog
            _editTransaction(tx);
          },
          child: Text('✏️ Edit'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    ),
  );
}

void _printTransaction(Map<String, dynamic> tx) async {
  //print(tx);
await printer.printCart(
  context: context,
  cart1: (tx['cart'] as List).cast<Map<String, dynamic>>(),
  total: tx['total'],
  mode: "print",
);

}

void _editTransaction(Map<String, dynamic> tx) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetailPage(
        cart1: (tx['cart'] as List).cast<Map<String, dynamic>>(),
        mode: "edit",
      ),
    ),
  );
}


  void _showDevicePickerDialog(BuildContext context, List<BluetoothDevice> devices) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Printer'),
          children: devices.map((device) {
            return SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close dialog first

                // Connect to selected device
                await bluetooth.connect(device);

                // Then print
                bluetooth.printNewLine();
                bluetooth.printCustom("Dosti Kitchen", 3, 1);
                bluetooth.printCustom("Table No: ${table['number']}", 1, 0);
                bluetooth.printNewLine();

                for (var item in table['orders']) {
                  bluetooth.printLeftRight(
                      "${item['name']} x${item['qty']}",
                      "Rs. ${item['qty'] * item['price']}", 1
                  );
                }

                bluetooth.printNewLine();
                bluetooth.printCustom("Total: Rs. ${table['total']}", 2, 2);
                bluetooth.printNewLine();
                // bluetooth.printQR("https://dostikitchen.in/order/${table['number']}", 200, 200, 1);
                bluetooth.printNewLine();
                bluetooth.paperCut();
                bluetooth.disconnect();
              },
              child: Text(device.name ?? "Unknown Device"),
            );
          }).toList(),
        );

      },
    );
  }


  Widget _scoreCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }



}

