import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Calender", style: TextStyle(
          fontSize: 30,
        ),),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: TableCalendar(
          locale: 'en_US',
          rowHeight: 43,
          headerStyle: const HeaderStyle(formatButtonVisible: false),
          focusedDay: today,
          firstDay: DateTime.utc(2023, 10, 20),
          lastDay: DateTime.utc(2033, 10, 20),
        ),
      ),
    );
  }
}
