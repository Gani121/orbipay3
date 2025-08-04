import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  String selectedIndustry = '';
  bool _showBusinessDetails = false;
  bool _showOnlinePaymentDetails = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Profile", style: TextStyle(fontSize: 20)),
            Text("FAST-VMS | 8298968751 | 65486", style: TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: Color(0xFF6A48FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture + Change
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        backgroundColor: Colors.grey[300],
                        child: _image == null
                            ? const Icon(Icons.person, size: 50, color: Colors.white70)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.notifications, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: _getImage,
                    child: const Text("Change", style: TextStyle(color: Colors.deepPurple)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Parking Ticket",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 20),

            // Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Industry",
                border: OutlineInputBorder(),
              ),
              value: selectedIndustry.isEmpty ? null : selectedIndustry,
              items: ['Hotel', 'Restaurant', 'Retail']
                  .map((industry) => DropdownMenuItem(
                        child: Text(industry),
                        value: industry,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedIndustry = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Input fields with mic icon
            _buildTextField("Business Name", Icons.mic),
            _buildTextField("Contact Person Name", Icons.mic),
            _buildTextField("Contact Person Phone"),
            _buildTextField("Contact Person Email"),

            const SizedBox(height: 12),

            // Section headers
  //          ExpansionPanelList(
  // expansionCallback: (int index, bool isExpanded) {
  //   setState(() {
  //     _showBusinessDetails = !_showBusinessDetails;
  //   });
  // },
  // expandedHeaderPadding: EdgeInsets.zero,
  // elevation: 1,
  // children: [
  //   ExpansionPanel(
  //     isExpanded: _showBusinessDetails,
  //     headerBuilder: (BuildContext context, bool isExpanded) {
  //       return ListTile(
  //         title: Text(
  //           "BUSINESS DETAILS",
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             color: Colors.deepPurple,
  //           ),
  //         ),
  //       );
  //     },
  //     body: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       child: Column(
  //         children: [
  //           _buildTextField("Business Address"),
  //           SizedBox(height: 10),
  //           _buildTextField("Postal Code"),
  //           SizedBox(height: 10),
  //           _buildTextField("City"),
  //           SizedBox(height: 10),
  //           _buildTextField("State"),
  //           SizedBox(height: 10),
  //           _buildTextField("GST Number"),
  //           SizedBox(height: 10),
  //           _buildTextField("FSSAI Number"),
  //           SizedBox(height: 10),
  //           _buildTextField("License Number"),
  //           SizedBox(height: 10),
  //           _buildTextField("PAN Number"),
  //         ],
  //       ),
   //   ),
  //  ),

    
//  ],
//),



ExpansionPanelList(
  expansionCallback: (int index, bool isExpanded) {
    setState(() {
      if (index == 0) _showBusinessDetails = !_showBusinessDetails;
      if (index == 1) _showOnlinePaymentDetails = !_showOnlinePaymentDetails;
    });
  },
  //expansionCallbackIndex: true, // Optional if needed by your code
  expandedHeaderPadding: EdgeInsets.zero,
  elevation: 1,
  children: [
    // Business Details Panel (index 0)
    ExpansionPanel(
      isExpanded: _showBusinessDetails,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
            "BUSINESS DETAILS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildTextField("Business Address"),
            SizedBox(height: 10),
            _buildTextField("Postal Code"),
            SizedBox(height: 10),
            _buildTextField("City"),
            SizedBox(height: 10),
            _buildTextField("State"),
            SizedBox(height: 10),
            _buildTextField("GST Number"),
            SizedBox(height: 10),
            _buildTextField("FSSAI Number"),
            SizedBox(height: 10),
            _buildTextField("License Number"),
            SizedBox(height: 10),
            _buildTextField("PAN Number"),
          ],
        ),
      ),
    ),


    // Online Payment Details Panel (index 1)
    ExpansionPanel(
      isExpanded: _showOnlinePaymentDetails,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
            "ONLINE PAYMENT DETAILS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildTextField("UPI ID"),
          ],
        ),
      ),
    ),
  ],
),


  
            const SizedBox(height: 60), // Add spacing for bottom button
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text("SAVE", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, [IconData? suffixIcon]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

Widget _buildTextField(String label) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
    validator: (value) => value!.isEmpty ? 'Enter $label' : null,
  );
}

