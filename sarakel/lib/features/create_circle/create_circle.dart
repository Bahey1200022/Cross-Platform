import 'package:flutter/material.dart';

import 'circle_controller.dart';

class CommunityType {
  final String name;
  final String description;

  CommunityType(this.name, this.description);
}

class CommunityForm extends StatefulWidget {
  final token;

  const CommunityForm({required this.token});

  @override
  _CommunityFormState createState() => _CommunityFormState();
}

class _CommunityFormState extends State<CommunityForm> {
  final TextEditingController _communityNameController =
      TextEditingController();
  CommunityType? _selectedCommunityType;
  bool _is18Plus = false; // Added: Flag for 18+ circle
  String _errorText = '';
  bool _circleExists = false;
  bool _isValidCommunityName = false;

  List<CommunityType> communityTypes = [
    CommunityType(
      'Public',
      'Anyone can view, post, and comment in this community.',
    ),
    CommunityType(
      'Restricted',
      'Anyone can view, but only approved users can post.',
    ),
    CommunityType(
      'Private',
      'Only approved users can view and submit to this community.',
    ),
  ];

  _CommunityFormState() {
    _selectedCommunityType = communityTypes.first;
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    super.dispose();
  }

  void _validateCommunityName(String name) {
    setState(() {
      _isValidCommunityName = RegExp(r'^[a-zA-Z0-9_]{3,21}$').hasMatch(name);
      _errorText = _isValidCommunityName
          ? ''
          : 'Circle names must be between 3-21 characters, and can only contain letters, numbers, or underscores.';
    });
  }

  bool _isCreateButtonEnabled() {
    String communityName = _communityNameController.text.trim();

    if (communityName.isEmpty) {
      _errorText = 'Community name cannot be empty.';
      return false;
    }

    return _isValidCommunityName &&
        _selectedCommunityType != null &&
        !_circleExists;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _checkCommunityExists(String communityName) async {
    bool circleExists =
        await CreateCircleController.checkCircleExists(communityName);
    bool idExists = await CreateCircleController.checkCircleIdExists(
        communityName.toLowerCase().replaceAll(' ', '_'));

    setState(() {
      _circleExists = circleExists || idExists;
      if (_circleExists) {
        _errorText =
            'Circle with the name "$communityName" already exists. Please choose a different name.';
      }
    });
  }

  void _createCircle() async {
    String communityName = _communityNameController.text.trim();
    String circleType = _selectedCommunityType!.name;

    if (_circleExists) {
      _showErrorSnackbar(
          'Circle with the name "$communityName" already exists. Please choose a different name.');
      return;
    }

    await CreateCircleController.createCircle(
        communityName, circleType, _is18Plus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Create Circles',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  TextField(
                    controller: _communityNameController,
                    onChanged: (value) {
                      _validateCommunityName(value);
                      _checkCommunityExists(value);
                    },
                    maxLength: 21,
                    decoration: InputDecoration(
                      labelText: 'Circle name',
                      prefixText: 'c/',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.0,
                    right: 12.0,
                    child: Text(
                      '${21 - _communityNameController.text.length}/21',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  _errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Circle type',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0),
              DropdownButton<CommunityType>(
                value: _selectedCommunityType,
                onChanged: (CommunityType? newValue) {
                  setState(() {
                    _selectedCommunityType = newValue;
                  });
                },
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
                items: communityTypes
                    .map<DropdownMenuItem<CommunityType>>(
                      (CommunityType communityType) =>
                          DropdownMenuItem<CommunityType>(
                        value: communityType,
                        child: Text(communityType.name),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                '${_selectedCommunityType?.description ?? ""}',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 24.0),
              Row(
                // Added: Toggle switch for 18+ circle
                children: [
                  Text(
                    '18+ circle',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Switch(
                    value: _is18Plus,
                    onChanged: (value) {
                      setState(() {
                        _is18Plus = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _isCreateButtonEnabled() ? _createCircle : null,
                child: Text(
                  'Create circle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
