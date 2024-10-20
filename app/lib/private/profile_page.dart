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
  late TextEditingController _fullNameController;
  late TextEditingController _numberController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool _isVisible = true;
  String _sexOption = 'Male';

  List<String> _healthItems = [
    'Diabetes',
    'High Blood Pressure',
    'Heart Disease',
    'Asthma',
    'Allergies',
  ];

  late List<bool> _checkedItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fullNameController = TextEditingController(text: 'Brutus Buckeye');
    _numberController = TextEditingController(text: '135');
    _addressController = TextEditingController(text: '100 Norwich Ave');
    _phoneController = TextEditingController(text: '1234567890');
    _emailController =
        TextEditingController(text: 'buckeye.1@buckeyemail.osu.edu');
    _checkedItems = List.generate(_healthItems.length, (index) => false);
    _checkedItems[4] = true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fullNameController.dispose();
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
        body: Padding(
          padding: EdgeInsets.all(16.0), // Global padding for the page
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'My Account',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Image.asset(
                        'assets/IMG_7421.png',
                        width: 80,
                        height: 80,
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
                      child: Card(
                        elevation: 4, // Adds shadow for depth
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Info:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: ListTile(
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
                                  ),
                                  Expanded(
                                    child: ListTile(
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
                                  ),
                                ],
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
                                decoration: InputDecoration(
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
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'My Health:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _toggleEditPreferences(_isVisible);
                                },
                                icon: Icon(Icons.edit), // Adding an icon
                                label: Text('Edit Information'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  appState.logout();
                                },
                                icon: Icon(Icons.logout), // Adding an icon
                                label: Text('Logout'),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  10), // Add some space between buttons and text
                          Text(
                            'My Profile:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Name: ' + _fullNameController.text,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Sex: ' + _sexOption,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Email: ' + _emailController.text,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Phone: ' + _phoneController.text,
                            style: TextStyle(
                              fontSize: 20,
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
      ),
    );
  }
}
