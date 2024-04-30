import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Function to check if the new password is valid
bool isNewPasswordValid(String password1, String password2) {
  return password1 == password2 && password1.length >= 8;
}

/// Function to check if the old password is valid
bool isOldPasswordValid(String oldPassword, String dataBasePassword) {
  return oldPassword == dataBasePassword;
}
