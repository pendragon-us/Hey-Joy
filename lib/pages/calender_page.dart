import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../utils/todo_tile.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  List<dynamic> _notesForSelectedDate = [];
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    _loadEvents();
    super.initState();
  }

  void _loadEvents() {
    Map<DateTime, List<dynamic>> events = {};
    for (var note in db.toDoList) {
      DateTime noteDate = DateFormat('MM-dd').parse(note[3].substring(0, 5));
      if (!events.containsKey(noteDate)) {
        events[noteDate] = [];
      }
      events[noteDate]!.add(note);
    }
    setState(() {
      _events = events;
    });
  }

  void _fetchNotesForSelectedDate(DateTime date) {
    String formattedDate = DateFormat('MM-dd').format(date);
    setState(() {
      _notesForSelectedDate = db.toDoList.where((note) {
        String noteDate = note[3].substring(0, 5);
        return noteDate == formattedDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchNotesForSelectedDate(selectedDay);
                },
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xff735bf2),
                    shape: BoxShape.rectangle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  String formattedDate = DateFormat('MM-dd').format(day);
                  return _events.keys.any((eventDay) {
                    return DateFormat('MM-dd').format(eventDay) == formattedDate;
                  }) ? ['Event'] : [];
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: _buildEventsMarker(day, events),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
            if (_notesForSelectedDate.isNotEmpty) ...[
              Text(
                'Notes for ${DateFormat.yMMMd().format(_selectedDay!)}',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _notesForSelectedDate.length,
                  itemBuilder: (context, index) {
                    var note = _notesForSelectedDate[index];
                    return ToDoTile(
                      taskName: note[0],
                      taskCompleted: note[1],
                      content: note[2],
                      date: note[3],
                      onChanged: (value) {},
                      deleteFunction: (context) {},
                    );
                  },
                ),
              ),
            ] else ...[
              Text(
                'No notes for this date',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<dynamic> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purpleAccent,
      ),
      width: 7.0,
      height: 7.0,
    );
  }
}
