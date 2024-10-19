import 'package:app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late TextEditingController _searchController;
  late TextEditingController
      _fullNameController; // New controller for full name input
  late TextEditingController _numberController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool _isVisible = true;
  String _sexOption = 'Male';
  var appState;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fullNameController = TextEditingController(); // Initialize the controller
    _numberController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fullNameController.dispose(); // Dispose the full name controller
    appState = context.watch<MyAppState>();
    super.dispose();
  }

  void _toggleEditPreferences(bool isVisible) {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'My Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ClipOval(
                    child: Image.asset(
                      'assets/IMG_7421.png', // Assuming the image is stored in the assets folder
                      width: 80, // Adjust the width as needed
                      height: 80, // Adjust the height as needed
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, brutus_buckeye!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: !_isVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Info:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        ListTile(
                          title: const Text('Male'),
                          leading: Radio<String>(
                            value: 'Male',
                            groupValue: _sexOption,
                            onChanged: (String? value) {
                              setState(() {
                                _sexOption = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Female'),
                          leading: Radio<String>(
                            value: 'Female',
                            groupValue: _sexOption,
                            onChanged: (String? value) {
                              setState(() {
                                _sexOption = value!;
                              });
                            },
                          ),
                        ),
                        TextFormField(
                          controller: _numberController,
                          keyboardType: TextInputType
                              .number, // Sets the input type to numeric
                          decoration: InputDecoration(
                            labelText: 'Weight (LBS)',
                            border: OutlineInputBorder(),
                          ),
                          // Optional: You can add input validation for numeric values
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType
                              .number, // Sets the input type to numeric
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          // Optional: You can add input validation for numeric values
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text(
                          'My Health:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _toggleEditPreferences(_isVisible);
                          },
                          child: Column(
                            children: [Text('Edit Information')],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            appState.logout();
                          },
                          child: Row(
                            children: [
                              Text('Logout'),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
