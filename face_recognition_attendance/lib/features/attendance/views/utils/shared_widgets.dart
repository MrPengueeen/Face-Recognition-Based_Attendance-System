import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAdvancedDropdown extends StatefulWidget {
  const MyAdvancedDropdown(
      {super.key,
      required this.items,
      required this.labelText,
      required this.icon});
  final List<String> items;
  final String labelText;
  final Icon icon;

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
    return Center(
      child: DropdownButtonFormField<String>(
        value: _selectedItem,
        onChanged: (String? value) {
          setState(() {
            _selectedItem = value!;
          });
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: UIConstants.colors.primaryPurple)),
        ),
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                widget.icon,
                const SizedBox(width: 10),
                Text(value),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget(
      {super.key,
      required this.dateTime,
      required this.incrementDate,
      required this.decrementDate,
      required this.day,
      required this.onClick});

  final DateTime dateTime;
  final Function incrementDate;
  final Function decrementDate;
  final Function onClick;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: UIConstants.colors.primaryPurple,
          onPressed: () {
            decrementDate();

            // setState(() {
            //   _updateDay();
            // });
          },
        ),
        const SizedBox(
          width: 30,
        ),
        InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: UIConstants.colors.primaryPurple,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: UIConstants.colors.primaryWhite,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "$day${DateFormat('MMMM dd, yyyy').format(dateTime)}",
                  style: TextStyle(color: UIConstants.colors.primaryWhite),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: UIConstants.colors.primaryPurple,
          onPressed: () {
            incrementDate();

            // setState(() {
            //   _updateDay();
            // });
          },
        ),
      ],
    );
  }
}
