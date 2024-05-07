// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screen to schedule a post
class SchedulePostScreen extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function(bool, DateTime, TimeOfDay) onScheduled;

  const SchedulePostScreen(
      {super.key,
      required this.selectedDate,
      required this.selectedTime,
      required this.onScheduled});

  @override
  _SchedulePostScreenState createState() => _SchedulePostScreenState();
}

/// State for SchedulePostScreen
class _SchedulePostScreenState extends State<SchedulePostScreen> {
  bool _isScheduled = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
    _loadDateTime();
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isScheduled = prefs.getBool('isScheduled') ?? false;
    });
    widget.onScheduled(_isScheduled, _selectedDate, _selectedTime);
  }

  void _loadDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDate = DateTime.parse(
          prefs.getString('selectedDate') ?? DateTime.now().toString());
      List<String> timeComponents =
          (prefs.getString('selectedTime') ?? TimeOfDay.now().toString())
              .split(":");
      _selectedTime = TimeOfDay(
          hour: int.parse(timeComponents[0]),
          minute: int.parse(timeComponents[1]));
    });
  }

  void _saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isScheduled', value);
    widget.onScheduled(value, _selectedDate, _selectedTime);
    if (!value) {
      // Clear date and time if switch is turned off
      prefs.remove('selectedDate');
      prefs.remove('selectedTime');
    }
  }

  void _saveDateTime(DateTime date, TimeOfDay time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDate', date.toString());
    prefs.setString('selectedTime', "${time.hour}:${time.minute}");
    print('Date: $date, Time: $time');
    widget.onScheduled(_isScheduled, date, time);
  }

  /// UI for scheduling a post
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Post'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Schedule post'),
            trailing: Switch(
              value: _isScheduled,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  _isScheduled = value;
                  _saveSwitchState(value); // Save state when switch is toggled
                  if (!value) {
                    // Clear date and time if switch is turned off
                    _selectedDate = DateTime.now();
                    _selectedTime = TimeOfDay.now();
                  }
                });
              },
            ),
          ),
          if (_isScheduled)
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Select Date'),
                  subtitle: Text(
                      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                  onTap: () => _selectDate(context),
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Select Time'),
                  subtitle:
                      Text('${_selectedTime.hour}:${_selectedTime.minute}'),
                  onTap: () => _selectTime(context),
                ),
              ],
            ),
          // Add more widgets as needed
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _saveDateTime(_selectedDate, _selectedTime);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _saveDateTime(_selectedDate, _selectedTime);
      });
    }
  }
}
