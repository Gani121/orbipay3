// models/transaction.dart
import 'package:objectbox/objectbox.dart';
import 'dart:convert'; // For jsonEncode/jsonDecode and utf8
@Entity()
class Transaction {
  int id = 0;
  //DateTime  time;
  int? tableNo;
  int total;
  String cartData; // Store as JSON string

  Transaction({
    //required this.time,
    this.tableNo,
    required this.total,
    required this.cartData,
  });

  List<Map<String, dynamic>> get decodedCart =>
      List<Map<String, dynamic>>.from(jsonDecode(cartData));
}
