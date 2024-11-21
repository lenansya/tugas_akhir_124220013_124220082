import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConverterPopup extends StatefulWidget {
  const TimeConverterPopup({Key? key}) : super(key: key);

  @override
  _TimeConverterPopupState createState() => _TimeConverterPopupState();
}

class _TimeConverterPopupState extends State<TimeConverterPopup> {
  final List<String> timezones = ["WIB", "WITA", "WIT", "London"];
  String selectedTimezone = "WIB";
  DateTime currentTime = DateTime.now();

  void _convertTime() {
    setState(() {
      switch (selectedTimezone) {
        case "WIB":
          currentTime = DateTime.now().toUtc().add(const Duration(hours: 7));
          break;
        case "WITA":
          currentTime = DateTime.now().toUtc().add(const Duration(hours: 8));
          break;
        case "WIT":
          currentTime = DateTime.now().toUtc().add(const Duration(hours: 9));
          break;
        case "London":
          currentTime =
              DateTime.now().toUtc().subtract(const Duration(hours: 1));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Konverter Waktu"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: selectedTimezone,
            onChanged: (value) {
              setState(() {
                selectedTimezone = value!;
                _convertTime();
              });
            },
            items: timezones
                .map((timezone) => DropdownMenuItem(
                      value: timezone,
                      child: Text(timezone),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'Waktu Saat Ini di $selectedTimezone:',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('HH:mm:ss').format(currentTime),
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}
