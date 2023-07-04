import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Color randBoxColor;

  @override
  Widget build(BuildContext context) {
    // Sort events by date
    _events.sort((a, b) => a['date'].compareTo(b['date']));

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: _events.length,
            itemBuilder: (BuildContext context, int index) {
              double height =
                  (100 + _events[index]['numContacts'] * 10).toDouble();
              double width = max(100, height);
              return SizedBox(
                height: height,
                width: width,
                child: Card(
                  color: randBoxColor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _events[index]['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Date: ${DateFormat('dd-MM').format(_events[index]['date'])}',
                          ),
                          Text(
                            'People: ${_events[index]['numContacts']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (int index) {
              int numContacts = _events[index]['numContacts'];
              double aspectRatio = 1 + numContacts * 0.1;
              return StaggeredTile.extent(2, aspectRatio * 100.0);
            },
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventCreationForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  final List<Map<String, dynamic>> _events = [];

  void _createEvent(String title, DateTime date, int numContacts) {
    randBoxColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    setState(() {
      _events.add({
        'title': title,
        'date': date,
        'numContacts': numContacts,
      });
    });
  }

  Future<void> _showEventCreationForm() async {
    TextEditingController eventTitleController = TextEditingController();
    DateTime? selectedDate;

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Create a new event',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: eventTitleController,
                decoration: const InputDecoration(
                  labelText: 'Event title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(selectedDate == null
                        ? 'Choose event date'
                        : 'Event date: ${selectedDate?.toLocal()}'
                            .split(' ')[0]),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_today),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        icon: const Icon(Icons.contact_page_outlined),
                        onPressed: () => {
                              _getContactPermission(),
                              _addFriendsFromContacts()
                            }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Add friends from contacts button
              ElevatedButton(
                onPressed: () {
                  String eventTitle = eventTitleController.text.trim();
                  if (eventTitle.isNotEmpty && selectedDate != null) {
                    // For demonstration purposes, generate a random number of contacts
                    int numContacts = Random().nextInt(10) + 0;
                    // Create the event
                    _createEvent(eventTitle, selectedDate!, numContacts);
                    // Close the bottom sheet
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addFriendsFromContacts() async {
    final PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // Fetch contacts from the device
      Iterable<Contact> contacts = await ContactsService.getContacts();
      // Add the contacts as friends to the event
      // ...
    } else {
      // Handle permission denied case
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Access denied'),
          content: const Text(
              'Please grant contacts access to add friends from your phone contacts.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  void _addEvent(String title, DateTime date, [int numContacts = 0]) {
    setState(() {
      _events.add({'title': title, 'date': date, 'numContacts': numContacts});
    });
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
