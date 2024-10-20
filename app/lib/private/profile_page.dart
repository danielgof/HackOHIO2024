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

  // List of health items for checkboxes
  List<String> _healthItems = [
    'Diabetes',
    'High Blood Pressure',
    'Heart Disease',
    'Asthma',
    'Allergies',
  ];

  // List to track which items are checked
  late List<bool> _checkedItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fullNameController = TextEditingController(
        text: 'Brutus Buckeye'); // Initialize the controller
    _numberController = TextEditingController(text: '135');
    _addressController = TextEditingController(text: '100 Norwich Ave');
    _phoneController = TextEditingController(text: '1234567890');
    _emailController =
        TextEditingController(text: 'buckeye.1@buckeyemail.osu.edu');

    // Initialize all health items to unchecked (false)
    _checkedItems = List.generate(_healthItems.length, (index) => false);
    _checkedItems[4] = true;
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
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'My Account',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _numberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Weight (LBS)',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'My Health:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _healthItems.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(_healthItems[index]),
                                value: _checkedItems[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _checkedItems[index] = value!;
                                  });
                                },
                              );
                            },
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
            ),
          ],
        ),
      ),
    );
  }
}
