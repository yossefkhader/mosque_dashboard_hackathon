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
              color: AppConsts.surfaceColorDark,
              border: Border(
                right: BorderSide(color: AppConsts.borderColor, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
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

                Divider(color: AppConsts.dividerColor),

                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      final isSelected = _selectedIndex == index;

                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppConsts.secondaryColor.withOpacity(0.15)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color:
                                      AppConsts.secondaryColor.withOpacity(0.3),
                                  width: 1)
                              : null,
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Icon(
                            item.icon,
                            color: isSelected
                                ? AppConsts.secondaryColor
                                : AppConsts.textColorTertiary,
                            size: 22,
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppConsts.secondaryColor
                                  : AppConsts.textColorSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontSize: 15,
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
                        side:
                            BorderSide(color: AppConsts.errorColor, width: 1.5),
                        foregroundColor: AppConsts.errorColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: AppConsts.errorColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
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
