import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  final Function(bool) onThemeChange;

  SettingScreen({required this.onThemeChange});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // You can retrieve the current theme mode from a persistent storage or shared preferences
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.onThemeChange(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Switch
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
            SizedBox(height: 20),
            // Account Settings
            ListTile(
              title: Text('Account Settings'),
              leading: Icon(Icons.account_circle),
              onTap: () {
                // Navigate to account settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            // App Info
            ListTile(
              title: Text('About App'),
              leading: Icon(Icons.info),
              onTap: () {
                // Show app information dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('About App'),
                      content: Text('Crypto App v1.0.0\nDeveloped by Your PRAJIN SHINGALA'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Sample AccountSettingsScreen for demonstration
class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Center(
        child: Text('Account settings go here.'),
      ),
    );
  }
}
