import 'package:flutter/material.dart';
import 'package:test1/bill_settings_page.dart';
import 'package:test1/profilepage.dart'; 
import 'printer_setup_page.dart';
import 'LanguageSelectionPage.dart';
import 'theme_setting/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  final List<String> settings = [
    "PROFILE SETTINGS",
    "BILLING SETTINGS",
    "PRINT SETTINGS",
    "LOYALTY DISCOUNT SETTINGS",
    "GET MORE CUSTOMERS SETTING",
    "STAFF SETTING",
    "UPLOAD DATA",
    "UPLOAD PARTIES",
    "START APP SETUP",
    "SELECT LANGUAGE",
    "DEMO MODE",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 84, 247),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orbipay', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
          ],
        ),
      ),
body: Container(
  color: Colors.grey[200],
  padding: EdgeInsets.all(16),
  child: ListView.builder(
    padding: EdgeInsets.only(top: 20), // 👈 Top margin
    itemCount: settings.length,
    itemBuilder: (context, index) {
      return Align(
        alignment: Alignment.center, // or Alignment.centerLeft
        
        child: Container(
          
          margin: EdgeInsets.only(bottom: 25), // 👈 spacing between buttons
          child: SizedBox(
            width: 330,
            height: 35,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 3, 135, 243),
                //padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Selected: ${settings[index]}')),
                // );


                //profile setting
                if(index == 0){

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
              //billing setting
                if(index == 1){

                Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  billSettingsPage()),
              );
                }

                //printer setting
                if(index == 2){

                Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  PrinterSetupPage()),
              );
                }

                 if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguageSelectionPage()),
            );
          }
  if (index == 8) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThemeSelectorPage()),
            );
          }

                

              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${index + 1}. ${settings[index]}',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  ),
),

    );
  }
}


