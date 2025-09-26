import 'package:flutter/material.dart';
import 'package:mosque_dashboard/pages/aiPage.dart';
import 'package:mosque_dashboard/appConsts.dart';
import 'package:mosque_dashboard/pages/calendarPage.dart';
import 'package:mosque_dashboard/pages/coursesPage.dart';
import 'package:mosque_dashboard/pages/dashboardPage.dart';
import 'package:mosque_dashboard/pages/settingsPages.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  VoidCallback? _refreshCalendarCallback;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(),
      CalendarPage(
          onRefreshRequested: (callback) =>
              _refreshCalendarCallback = callback),
      AIPage(onEventsAdded: _refreshCalendar),
      CoursesPage(),
      SettingsPage(),
    ];
  }

  void _refreshCalendar() {
    // Refresh calendar when events are added from AI
    _refreshCalendarCallback?.call();
    // Switch to calendar tab to show the new events
    setState(() {
      _selectedIndex = 1;
    });
  }

  final List<NavigationItem> _navItems = [
    NavigationItem(icon: Icons.dashboard, label: 'لوحة التحكم'),
    NavigationItem(icon: Icons.calendar_month, label: 'تقويم المسجد'),
    NavigationItem(icon: Icons.auto_awesome, label: 'الذكاء الاصطناعي'),
    NavigationItem(icon: Icons.work, label: 'الوحدات التعليمية'),
    NavigationItem(icon: Icons.settings, label: 'الإعدادات'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: AppConsts.primaryColor, // Darker shade
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    AppConsts.logoPath,
                    fit: BoxFit.fitWidth,
                  ),
                ),

                Divider(color: Colors.white24),

                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      final isSelected = _selectedIndex == index;

                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFFFFD700).withOpacity(0.2)
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            item.icon,
                            color:
                                isSelected ? Color(0xFFFFD700) : Colors.white70,
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Color(0xFFFFD700)
                                  : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Logout Button
                Container(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFFFD700)),
                        foregroundColor: Color(0xFFFFD700),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Color(0xFFFFD700),
                          ),
                          SizedBox(width: 10),
                          Text('تسجيل الخروج'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
