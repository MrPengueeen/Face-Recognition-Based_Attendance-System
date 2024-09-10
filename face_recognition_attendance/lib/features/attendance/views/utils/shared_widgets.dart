import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';

class MyAdvancedDropdown extends StatefulWidget {
  const MyAdvancedDropdown({super.key, required this.items});
  final List<String> items;

  @override
  _MyAdvancedDropdownState createState() => _MyAdvancedDropdownState();
}

class _MyAdvancedDropdownState extends State<MyAdvancedDropdown> {
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: DropdownButtonFormField<String>(
          value: _selectedItem,
          onChanged: (String? value) {
            setState(() {
              _selectedItem = value!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Select a classroom',
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: UIConstants.colors.primaryPurple)),
          ),
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  const Icon(Icons.other_houses_outlined),
                  const SizedBox(width: 10),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
