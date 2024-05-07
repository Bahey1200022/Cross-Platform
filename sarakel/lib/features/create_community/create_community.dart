// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'community_controller.dart';

///Community Type class to get the name and description of the community
class CommunityType {
  final String name;
  final String description;

  CommunityType(this.name, this.description);
}

class CommunityForm extends StatefulWidget {
  final String token;

  const CommunityForm({super.key, required this.token});

  @override
  _CommunityFormState createState() => _CommunityFormState();
}

///Community Form State to get the community name, type, NSFW and push to the community profile page
class _CommunityFormState extends State<CommunityForm> {
  final TextEditingController _communityNameController =
      TextEditingController();
  CommunityType? _selectedCommunityType;
  bool _is18Plus = false;
  String _errorText = '';
  bool _isValidCommunityName = false;

  List<CommunityType> communityTypes = [
    CommunityType(
      'public',
      'Anyone can view, post, and comment in this community.',
    ),
    CommunityType(
      'restricted',
      'Anyone can view, but only approved users can post.',
    ),
    CommunityType(
      'private',
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

  ///Validate the community name rules
  void _validateCommunityName(String name) {
    setState(() {
      _isValidCommunityName = RegExp(r'^[a-zA-Z0-9_]{3,21}$').hasMatch(name);
      _errorText = _isValidCommunityName
          ? ''
          : 'Community names must be between 3-21 characters, and can only contain letters, numbers, or underscores.';
    });
  }

  ///Enable the create button if the community name is valid and the community type is selected
  bool _isCreateButtonEnabled() {
    String communityName = _communityNameController.text.trim();

    if (communityName.isEmpty) {
      _errorText = 'Community name cannot be empty.';
      return false;
    }

    return _isValidCommunityName && _selectedCommunityType != null;
  }

  // ignore: unused_element
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _createCommunity() async {
    String communityName = _communityNameController.text.trim();
    String communityType = _selectedCommunityType!.name;

    await CreateCommunityController.createCommunity(
        communityName, communityType, _is18Plus, context);
  }

  Widget _getIconForCommunityType(String communityTypeName) {
    IconData iconData;

    switch (communityTypeName) {
      case 'public':
        iconData = Icons.public;
        break;
      case 'restricted':
        iconData = Icons.remove_red_eye_outlined;
        break;
      case 'private':
        iconData = Icons.lock_outline;
        break;
      default:
        iconData = Icons.error;
        break;
    }

    return Icon(
      iconData,
      color: Colors.black,
    );
  }

  //UI for creating a community
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Create Community',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  TextField(
                    cursorColor: Colors.black,
                    controller: _communityNameController,
                    onChanged: (value) {
                      _validateCommunityName(value);
                    },
                    maxLength: 21,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black),
                      labelText: 'Community name',
                      prefixText: 'c/',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.0,
                    right: 12.0,
                    child: Text(
                      '${21 - _communityNameController.text.length}/21',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  _errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Community type',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonHideUnderline(
                child: DropdownButton<CommunityType>(
                  value: _selectedCommunityType,
                  //autofocus: false,
                  onChanged: (CommunityType? newValue) {
                    setState(() {
                      _selectedCommunityType = newValue;
                    });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  elevation: 8,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  items: communityTypes
                      .map<DropdownMenuItem<CommunityType>>(
                        (CommunityType communityType) =>
                            DropdownMenuItem<CommunityType>(
                                value: communityType,
                                child: Row(
                                  children: [
                                    _getIconForCommunityType(
                                        communityType.name),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(communityType.name)
                                  ],
                                )),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                _selectedCommunityType?.description ?? "",
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const SizedBox(height: 24.0),
              Row(
                // Added: Toggle switch for 18+ community
                children: [
                  const Text(
                    '18+ community',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Switch(
                    value: _is18Plus,
                    onChanged: (value) {
                      setState(() {
                        _is18Plus = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _isCreateButtonEnabled() ? _createCommunity : null,
                child: const Text(
                  'Create community',
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
