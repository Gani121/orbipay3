import 'package:objectbox/objectbox.dart';

@Entity()
class MenuItem {
  @Id()
  int id = 0;

  String name;
  String sellPrice;
  String sellPriceType;
  String category;
  String? mrp;
  String? purchasePrice;
  String? acSellPrice;
  String? nonAcSellPrice;
  String? onlineDeliveryPrice;
  String? onlineSellPrice;
  String? hsnCode;
  String? itemCode;
  String? barCode;
  String? barCode2;
  String? imagePath;
  int? available;
  int? adjustStock;
  double? gstRate;
  bool? withTax;
  double? cessRate;

  // Cart-related fields
  bool selected;
  int qty;

  MenuItem({
    this.id = 0,
    required this.name,
    required this.sellPrice,
    required this.sellPriceType,
    required this.category,
    this.mrp,
    this.purchasePrice,
    this.acSellPrice,
    this.nonAcSellPrice,
    this.onlineDeliveryPrice,
    this.onlineSellPrice,
    this.hsnCode,
    this.itemCode,
    this.barCode,
    this.barCode2,
    this.imagePath,
    this.available,
    this.adjustStock,
    this.gstRate,
    this.withTax,
    this.cessRate,
    this.selected = false,
    this.qty = 0,
  });

  // CopyWith method for immutable updates
  MenuItem copyWith({
    int? id,
    String? name,
    String? sellPrice,
    String? sellPriceType,
    String? category,
    String? mrp,
    String? purchasePrice,
    String? acSellPrice,
    String? nonAcSellPrice,
    String? onlineDeliveryPrice,
    String? onlineSellPrice,
    String? hsnCode,
    String? itemCode,
    String? barCode,
    String? barCode2,
    String? imagePath,
    int? available,
    int? adjustStock,
    double? gstRate,
    bool? withTax,
    double? cessRate,
    bool? selected,
    int? qty,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sellPrice: sellPrice ?? this.sellPrice,
      sellPriceType: sellPriceType ?? this.sellPriceType,
      category: category ?? this.category,
      mrp: mrp ?? this.mrp,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      acSellPrice: acSellPrice ?? this.acSellPrice,
      nonAcSellPrice: nonAcSellPrice ?? this.nonAcSellPrice,
      onlineDeliveryPrice: onlineDeliveryPrice ?? this.onlineDeliveryPrice,
      onlineSellPrice: onlineSellPrice ?? this.onlineSellPrice,
      hsnCode: hsnCode ?? this.hsnCode,
      itemCode: itemCode ?? this.itemCode,
      barCode: barCode ?? this.barCode,
      barCode2: barCode2 ?? this.barCode2,
      imagePath: imagePath ?? this.imagePath,
      available: available ?? this.available,
      adjustStock: adjustStock ?? this.adjustStock,
      gstRate: gstRate ?? this.gstRate,
      withTax: withTax ?? this.withTax,
      cessRate: cessRate ?? this.cessRate,
      selected: selected ?? this.selected,
      qty: qty ?? this.qty,
    );
  }

  // Factory constructor from Map
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      sellPrice: map['sellPrice'] ?? '0',
      sellPriceType: map['sellPriceType'] ?? '',
      category: map['category'] ?? '',
      mrp: map['mrp'],
      purchasePrice: map['purchasePrice'],
      acSellPrice: map['acSellPrice'],
      nonAcSellPrice: map['nonAcSellPrice'],
      onlineDeliveryPrice: map['onlineDeliveryPrice'],
      onlineSellPrice: map['onlineSellPrice'],
      hsnCode: map['hsnCode'],
      itemCode: map['itemCode'],
      barCode: map['barCode'],
      barCode2: map['barCode2'],
      imagePath: map['imagePath'],
      available: map['available'],
      adjustStock: map['adjustStock'],
      gstRate: map['gstRate']?.toDouble(),
      withTax: map['withTax'],
      cessRate: map['cessRate']?.toDouble(),
      selected: map['selected'] ?? false,
      qty: map['qty'] ?? 0,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sellPrice': sellPrice,
      'sellPriceType': sellPriceType,
      'category': category,
      'mrp': mrp,
      'purchasePrice': purchasePrice,
      'acSellPrice': acSellPrice,
      'nonAcSellPrice': nonAcSellPrice,
      'onlineDeliveryPrice': onlineDeliveryPrice,
      'onlineSellPrice': onlineSellPrice,
      'hsnCode': hsnCode,
      'itemCode': itemCode,
      'barCode': barCode,
      'barCode2': barCode2,
      'imagePath': imagePath,
      'available': available,
      'adjustStock': adjustStock,
      'gstRate': gstRate,
      'withTax': withTax,
      'cessRate': cessRate,
      'selected': selected,
      'qty': qty,
    };
  }

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, price: $sellPrice, selected: $selected, qty: $qty)';
  }

  // Optional: Equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}