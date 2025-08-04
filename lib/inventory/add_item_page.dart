import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/menu_item.dart';
import 'package:objectbox/objectbox.dart';
import '../models/objectbox.g.dart'; // This will be generated

class AddItemPage extends StatefulWidget {
  final Store? store; // 👈 made nullable
  final MenuItem? item; // 👈 optional edit

  const AddItemPage({Key? key, this.store, this.item}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  late final Box<MenuItem> _menuItemBox;

  File? _image;
  final picker = ImagePicker();
  String? _imagePath;


  // Controllers for main fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sellPriceController = TextEditingController();
  final TextEditingController mrpController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();

  // Controllers for parking fields
  final TextEditingController acSellPrice1Controller = TextEditingController();
  final TextEditingController nonAcSellPrice1Controller = TextEditingController();
  final TextEditingController onlineDeliveryPriceController = TextEditingController();
  final TextEditingController onlineSellPriceController = TextEditingController();

  // Controllers for product details
  final TextEditingController hsnCodeController = TextEditingController();
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController barCodeController = TextEditingController();
  final TextEditingController barCode2Controller = TextEditingController();

  // Controllers for tax gst
  final TextEditingController availableController = TextEditingController();
  final TextEditingController adjustStockController = TextEditingController();
  final TextEditingController gstRateController = TextEditingController();


  // In your widget's state class
  final TextEditingController _gstRateController = TextEditingController();
  final TextEditingController _cessRateController = TextEditingController();
  final TextEditingController _withTaxController = TextEditingController(text: 'false'); // Default to "WITHOUT TAX"

  // State for expandable sections
  bool _showProductDetails = false;
  bool _showInventoryDetails = false;
  bool _showProductDisplay = false;
  bool _showGstTax = false;

  String? selectedCategory;
  String sellPriceType = '₹';

  List<String> categories = [];


  @override
  void initState() {
    super.initState();
    
   if (widget.store != null) {
    _menuItemBox = widget.store!.box<MenuItem>();
  } else {
    // Handle the null case (log, show error/snackbar, etc.)
    // For now, we’ll just print a warning
    print("⚠️ Store is null! _menuItemBox not initialized.");
  }
    _loadCategories();
    // Initialize with default values
    _gstRateController.text = '0.0'; // Default GST rate
    _cessRateController.text = '0.0'; // Default CESS rate

    if (widget.item != null) {
      final item = widget.item!;
      nameController.text = item.name;
      sellPriceController.text = item.sellPrice;
      sellPriceType = item.sellPriceType;
      selectedCategory = item.category;
      mrpController.text = item.mrp.toString();
      purchasePriceController.text = item.purchasePrice.toString();
      acSellPrice1Controller.text = item.acSellPrice.toString();
      nonAcSellPrice1Controller.text = item.nonAcSellPrice.toString();
      onlineDeliveryPriceController.text = item.onlineDeliveryPrice.toString();
      onlineSellPriceController.text = item.onlineSellPrice.toString();
      hsnCodeController.text = item.hsnCode.toString();
      itemCodeController.text = item.itemCode.toString();
      barCodeController.text = item.barCode.toString();
      barCode2Controller.text = item.barCode2.toString();
      availableController.text = item.available.toString();
      adjustStockController.text = item.adjustStock.toString();
      gstRateController.text = item.gstRate.toString();
      _cessRateController.text = item.cessRate.toString();
      _withTaxController.text = item.withTax.toString();
      _imagePath = item.imagePath;
      if (_imagePath != null) {
        _image = File(_imagePath!);
      }
    }
  
  }

  @override
  void dispose() {
    _gstRateController.dispose();
    _cessRateController.dispose();
    _withTaxController.dispose();
    super.dispose();
  }


// copy file and store in app path
// Future<void> _pickImage() async {
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     final appDir = await getApplicationDocumentsDirectory();
//     final fileName = pickedFile.name;
//     final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

//     setState(() {
//       _image = savedImage;
//       _imagePath = savedImage.path;
//     });
//   }
// }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
  }
Future<void> _saveItem() async {
  if (_formKey.currentState!.validate()) {
    final isEditing = widget.item != null;
    final menuItem = MenuItem(
      id: isEditing ? widget.item!.id : 0,
      name: nameController.text,
      sellPrice: sellPriceController.text,
      sellPriceType: sellPriceType,
      category: selectedCategory ?? '',
      mrp: mrpController.text,
      purchasePrice: purchasePriceController.text,
      acSellPrice: acSellPrice1Controller.text,
      nonAcSellPrice: nonAcSellPrice1Controller.text,
      onlineDeliveryPrice: onlineDeliveryPriceController.text,
      onlineSellPrice: onlineSellPriceController.text,
      hsnCode: hsnCodeController.text,
      itemCode: itemCodeController.text,
      barCode: barCodeController.text,
      barCode2: barCode2Controller.text,
      imagePath: _imagePath,
      available: int.tryParse(availableController.text) ?? 1,
      adjustStock: int.tryParse(adjustStockController.text) ?? 1,
      gstRate: double.tryParse(_gstRateController.text) ?? 0.0,
      cessRate: double.tryParse(_cessRateController.text) ?? 0.0,
      withTax: bool.tryParse(_withTaxController.text) ?? false,
    );

    final id = _menuItemBox.put(menuItem); // ✅ get actual ID from ObjectBox
    final updatedItem = _menuItemBox.get(id); // ✅ fetch saved version from disk

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Item Saved')),
    );


  //print(updatedItem);

    Navigator.pop(context, updatedItem); // ✅ Return fresh object to calling page
  }
}


  void _loadCategories() {
    final items = _menuItemBox.getAll();
    final uniqueCategories = <String>{};
    for (final item in items) {
      if (item.category.trim().isNotEmpty) {
        uniqueCategories.add(item.category.trim());
      }
    }
    setState(() {
      categories = uniqueCategories.toList()..sort();
    });
  }


  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Item" : "New Item"),
        backgroundColor: Colors.purple.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Upload Image
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, color: Colors.grey, size: 30),
                            Text("Upload Item Image", style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),

              // Product Name
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product/Service Name *',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.mic),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Sell Price
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: sellPriceController,
                      decoration: InputDecoration(
                        labelText: 'Sell Price *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter sell price';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Sell Price Type',
                        border: OutlineInputBorder(),
                      ),
                      value: sellPriceType,
                      items: ['₹', '%'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sellPriceType = value ?? '₹';
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Item Category *',
                  border: OutlineInputBorder(),
                ),
                value: selectedCategory,
                items: [
                  ...categories.map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  )).toList(),
                  DropdownMenuItem<String>(
                    value: 'new_category',
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 18, color: Colors.purple),
                        SizedBox(width: 8),
                        Text('Add New Category', style: TextStyle(color: Colors.purple)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) async {
                  if (value == 'new_category') {
                    final newCategoryController = TextEditingController();
                    final newCategory = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add New Category'),
                          content: TextField(
                            controller: newCategoryController,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Category Name',
                              hintText: 'Enter new category name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (newCategoryController.text.trim().isNotEmpty) {
                                  Navigator.pop(context, newCategoryController.text.trim());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                              ),
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                    );

                    if (newCategory != null && newCategory.isNotEmpty) {
                      if (!categories.contains(newCategory)) {
                        setState(() {
                          categories.add(newCategory);
                          selectedCategory = newCategory;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Category already exists!')),
                        );
                        setState(() {
                          selectedCategory = newCategory;
                        });
                      }
                    }
                  } else {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // MRP + Purchase
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: mrpController,
                      decoration: InputDecoration(
                        labelText: 'MRP',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: purchasePriceController,
                      decoration: InputDecoration(
                        labelText: 'Purchase Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // AC Sell Price
              TextFormField(
                controller: acSellPrice1Controller,
                decoration: InputDecoration(
                  labelText: 'AC Sell Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              // Non-AC Sell Price
              TextFormField(
                controller: nonAcSellPrice1Controller,
                decoration: InputDecoration(
                  labelText: 'Non-AC Sell Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              // Online Delivery Price
              TextFormField(
                controller: onlineDeliveryPriceController,
                decoration: InputDecoration(
                  labelText: 'Online Delivery Sell Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              // Online Sell Price
              TextFormField(
                controller: onlineSellPriceController,
                decoration: InputDecoration(
                  labelText: 'Online Sell Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              // GST AND TAX Section
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showGstTax = !_showGstTax;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                  side: BorderSide(color: Colors.purple.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "GST AND TAX (OPTIONAL)",
                      style: TextStyle(color: Colors.purple.shade700),
                    ),
                    Icon(
                      _showGstTax ? Icons.expand_less : Icons.expand_more,
                      color: Colors.purple.shade700,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (_showGstTax) ...[
                SizedBox(height: 10),
                TextFormField(
                  controller: _gstRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "GST %",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.percent),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Prices With/Without Tax?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text("WITH TAX"),
                        selected: _withTaxController.text == 'true',
                        onSelected: (selected) {
                          setState(() {
                            _withTaxController.text = 'true';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: Text("WITHOUT TAX"),
                        selected: _withTaxController.text == 'false',
                        onSelected: (selected) {
                          setState(() {
                            _withTaxController.text = 'false';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _cessRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "CESS %",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.percent),
                  ),
                ),
                SizedBox(height: 10),
              ],

              // PRODUCT DETAILS Section
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showProductDetails = !_showProductDetails;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                  side: BorderSide(color: Colors.purple.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PRODUCT DETAILS (OPTIONAL)",
                      style: TextStyle(color: Colors.purple.shade700),
                    ),
                    Icon(
                      _showProductDetails ? Icons.expand_less : Icons.expand_more,
                      color: Colors.purple.shade700,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (_showProductDetails) ...[
                SizedBox(height: 10),
                TextFormField(
                  controller: hsnCodeController,
                  decoration: InputDecoration(
                    labelText: 'HSN/SAC Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: itemCodeController,
                  decoration: InputDecoration(
                    labelText: 'Item Code/SKU',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: barCodeController,
                  decoration: InputDecoration(
                    labelText: 'Bar Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: barCode2Controller,
                  decoration: InputDecoration(
                    labelText: 'Bar Code 2',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
              ],

              // INVENTORY DETAILS Section
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showInventoryDetails = !_showInventoryDetails;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                  side: BorderSide(color: Colors.purple.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "INVENTORY DETAILS (OPTIONAL)",
                      style: TextStyle(color: Colors.purple.shade700),
                    ),
                    Icon(
                      _showInventoryDetails ? Icons.expand_less : Icons.expand_more,
                      color: Colors.purple.shade700,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // PRODUCT DISPLAY Section
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showProductDisplay = !_showProductDisplay;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                  side: BorderSide(color: Colors.purple.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PRODUCT DISPLAY (OPTIONAL)",
                      style: TextStyle(color: Colors.purple.shade700),
                    ),
                    Icon(
                      _showProductDisplay ? Icons.expand_less : Icons.expand_more,
                      color: Colors.purple.shade700,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // SAVE Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text("SAVE", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}