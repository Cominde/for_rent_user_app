import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toastification/toastification.dart';

class CustomCalendarWidget extends StatefulWidget {
  final List<DateTime> busyDates;
  List<DateTime> dates = [];

  CustomCalendarWidget({required this.busyDates});

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();


  List<DateTime?> _selectedDates = [null, null];



  List<DateTime> _getDatesInRange(DateTime start, DateTime? end) {
    widget.dates=[];
    if(end != null) {
      for (int i = 0; i <= end.difference(start).inDays; i++) {
        widget.dates.add(start.add(Duration(days: i)));
      }
    } else {
      widget.dates.add(start);
    }

    return widget.dates;
  }



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Colors.lightGreenAccent,
              selectedDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
              todayDecoration:  BoxDecoration(
                color: Colors.lightGreen[200],
                shape: BoxShape.circle,
              ),
            ),

            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            availableGestures: AvailableGestures.none,
            headerStyle: HeaderStyle(
                formatButtonShowsNext: false,
                formatButtonVisible: false
            ),

            selectedDayPredicate: (day) {
              return isSameDay(_selectedDates[0], day) || isSameDay(_selectedDates[1], day);
            },
            rangeStartDay: _selectedDates[0],
            rangeEndDay: _selectedDates[1],

            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },




            onDaySelected: (selectedDay, focusedDay) {
              if (!widget.busyDates.contains(
                  DateTime.parse(selectedDay.toString().substring(0,selectedDay.toString().length-1))
              )) {
                setState(() {

                  if(_selectedDates[0]==null) {
                    _selectedDates[0] = selectedDay;
                  }
                  else if(_selectedDates[0]==selectedDay){
                    _selectedDates[0]=null;
                    _selectedDates[1]=null;
                    widget.dates = [];
                  }
                  else {

                    if(selectedDay.isBefore(_selectedDates[0]!))
                      {

                      }
                    else if (!_containsBusyDates(_selectedDates[0], selectedDay)) {
                      setState(() {
                        _selectedDates[1] = selectedDay;

                      });
                    } else {
                      _selectedDates[1]=null;
                      toastification.show(
                        title: Text('Range includes busy dates'),
                        autoCloseDuration: const Duration(seconds: 5),
                        type: ToastificationType.error,
                        style: ToastificationStyle.flatColored,
                      );
                      /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Range includes busy dates'),
                      ));*/
                    }
                  }

                });
              } else {
                toastification.show(
                  title: Text('Cannot select busy date'),
                  autoCloseDuration: const Duration(seconds: 5),
                  type: ToastificationType.error,
                  style: ToastificationStyle.flatColored,
                );
                /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Cannot select busy date'),
                ));*/
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              if (!_containsBusyDates(start, end)) {
                // print(start);
                setState(() {
                  _selectedDates[0] = start;
                  _selectedDates[1] = end;
                  _focusedDay = focusedDay;
                });
              } else {
                toastification.show(
                  title: Text('Range includes busy dates'),
                  autoCloseDuration: const Duration(seconds: 5),
                  type: ToastificationType.error,
                  style: ToastificationStyle.flatColored,
                );
                /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Range includes busy dates'),
                ));*/
              }
            },
            calendarBuilders:
            CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
              bool isBusy = false;
              widget.busyDates.forEach((date) {

                if (date.toString()==day.toString().substring(0,day.toString().length-1) ) {
                  isBusy = true;
                  return ;
                }
              });
              if (isBusy == true) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return null;
            }),
          ),
          SizedBox(height: 5),
          if(_selectedDates[0] != null && _selectedDates[1] == null) Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Press the same selected day to cancel',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey
              ),
            ),
          ),
          if(_selectedDates[0] != null && _selectedDates[1] != null) Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Press the selected start day to cancel',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey
              ),
            ),
          ),
          SizedBox(height: 20),
          if (_selectedDates[0] != null && _selectedDates[1] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Start Date: ${_selectedDates[0]!.toLocal().toString().split(' ')[0]}',
                  ),
                  Text(
                    'Selected End Date: ${_selectedDates[1]!.toLocal().toString().split(' ')[0]}',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'All Dates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._getDatesInRange(
                      _selectedDates[0]!, _selectedDates[1]!)
                      .map((date) => Text(date.toLocal().toString().split(' ')[0]))
                      .toList(),
                ],
              ),
            ),
          if (_selectedDates[0] != null && _selectedDates[1] == null)
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Date: ${_selectedDates[0]!.toLocal().toString().split(' ')[0]}',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'All Dates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._getDatesInRange(
                      _selectedDates[0]!, _selectedDates[1])
                      .map((date) => Text(date.toLocal().toString().toString().split(' ')[0]))
                      .toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _containsBusyDates(start,end) {
    //print('hobaa');



    for (var busyDate in widget.busyDates) {
      if (busyDate.isAfter(start) &&
          busyDate.isBefore(end)) {
        return true;
      }
    }
    return false;
  }
}
