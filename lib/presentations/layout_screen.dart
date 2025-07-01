
import 'package:flutter/material.dart';
import 'package:todo_bloc/presentations/tabs/calendar/screens/calendar_screen.dart';
import 'package:todo_bloc/presentations/tabs/today/screens/today_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {

  final List<Widget> _pages = [TodayScreen(), CalendarScreen()];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    

    body: _pages[selectedIndex],


      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_rounded),
            label: "Today",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
