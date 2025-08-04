import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'cartprovier/cart_provider.dart';
import 'package:provider/provider.dart';


import 'models/objectbox.g.dart';
import 'models/transaction.dart';

import 'cartprovier/ObjectBoxService.dart';

class BillPrinter {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Function()? onTransactionAdded;

  Future<void> printCart({
    required BuildContext context,
    required List<Map<String, dynamic>> cart1,
    required int total,
    required String mode,
    //required Store Store,
  }) async {
    try {
    
    final cart = cart1;
    print("🛒 Cart data: $cart1");

      final device = await _getSavedPrinter();
      if (device == null) {
        print("❌ No saved printer found.");
        return;
      }

      bool? connected = await bluetooth.isConnected;
      if (connected != true) {
        await bluetooth.connect(device);
      }

      bluetooth.printNewLine();
      bluetooth.printCustom("Dosti Kitchen", 3, 1);
      //bluetooth.printCustom("Cart Bill", 1, 1);
      bluetooth.printNewLine();

      for (var item in cart) {
        String name = item['name'] ?? 'Item';
        int qty = item['qty'] ?? 0;
        int price = int.tryParse(item['sellPrice'] ?? '') ?? 0;
        bluetooth.printLeftRight("$name x$qty", "Rs.${qty * price}", 1);
      }

      bluetooth.printNewLine();
      bluetooth.printCustom("Total: Rs.$total", 2, 2);

      bluetooth.printNewLine();
      bluetooth.printCustom("Thank you!", 1, 1);
      bluetooth.printNewLine();
      bluetooth.paperCut();
      bluetooth.disconnect();

      print("✅ Printed successfully.");

          // ✅ Go back two pages
    
        // try{
        //   Navigator.pop(context); // Pops current
        //   Navigator.pop(context);
        // }catch(e){
        //   bluetooth.disconnect();
        // }
   
    // Future.delayed(Duration.zero, () {
    //   Navigator.pop(context); // Pops one more after frame
    // });





        
     


      // ✅ Save to recent transactions
      if(mode=="settle") {
        print("cart to store ata $cart");
        await _saveTransactionToObjectBox(
          context: context,
          cart: cart,
          total: total,
          tableNo: 1,

        );

      }

     
    } catch (e) {
      print("❌ Error while printing: $e");
      bluetooth.disconnect();
    }
  }

Future<void> _saveTransactionToObjectBox({
  required BuildContext context,
  required List<Map<String, dynamic>> cart,
  required int total,
  int? tableNo,
}) async {
  final store = Provider.of<ObjectBoxService>(context, listen: false).store;
  final box = store.box<Transaction>();

final tx = Transaction(
  //time: DateTime.now().toIso8601String(),
  tableNo: tableNo,
  total: total,
  cartData: jsonEncode(cart), // encode List<Map<String, dynamic>> to String
);



  box.put(tx);

  print("✅ Transaction saved to ObjectBox.");
  onTransactionAdded?.call();
  print("🔁 Transaction added callback fired!");
  final cartProvider = Provider.of<CartProvider>(context, listen: false);;
  cartProvider.clearCart();

  Navigator.pop(context);
  Navigator.pop(context);
}

  Future<BluetoothDevice?> _getSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('saved_printer_address');
    if (address == null) return null;

    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    try {
      return devices.firstWhere((d) => d.address == address);
    } catch (e) {
      return null; // Return null if no match found
    }
  }


  // Optional: Call this at app start (e.g., in main or splash)
  Future<void> autoConnectIfSaved() async {
    final device = await _getSavedPrinter();
    if (device == null) return;

    try {
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected != true) {
        await bluetooth.connect(device);
        print("✅ Auto-connected to saved printer.");
      }
    } catch (e) {
      print("❌ Auto-connect failed: $e");
    }
  }

  // Optional: Save printer on setup page
  static Future<void> savePrinter(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_printer_address', device.address ?? '');
    print("✅ Saved printer: ${device.name}");
  }
}
