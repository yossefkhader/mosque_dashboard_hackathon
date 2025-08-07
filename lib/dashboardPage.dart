import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const welcomeMessage= "السلام عليكم " "<" "اسم المستخدم" ">";
    const mosqueMessage = "أنت تنشط في مسجد " "<" "اسم المسجد" ">";

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'لوحة التحكم',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Text(
              welcomeMessage,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text(
              mosqueMessage,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            )
          ),
          SizedBox(height: 20,),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: screenWidth/(screenHeight+100),
              shrinkWrap: true,
              children: [
                _buildPrayerTimerCard(screenWidth,'حتى موعد الصلاة القادمة', Icons.alarm),
                _buildDashboardCard(screenWidth,'حتى الفعالية القادمة', '12 يوم', Icons.hourglass_top),
                _buildDashboardCard(screenWidth,'في طاقم المسجد', '5 أشخاص', Icons.people),
                _buildDashboardCard(screenWidth,'اكملتها في العام الحالي', '3 وحدات', Icons.work),
                _buildDashboardCard(screenWidth,'الميزانية السنوية للفعاليات', '25,000 شاقل', Icons.monetization_on),
                _buildDashboardCard(screenWidth,'من الميزانية تم استخدامها', '30%', Icons.incomplete_circle),
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildDashboardCard(double screenWidth, String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: screenWidth/35, color: Color(0xFFFFD700)),
          SizedBox(height: screenWidth/100),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth/57,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenWidth/280),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimerCard(double screenWidth, String title, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: screenWidth/35, color: Color(0xFFFFD700)),
          SizedBox(height: screenWidth/100),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TimerCountdown(
              format: CountDownTimerFormat.hoursMinutesSeconds,
              endTime: DateTime.now().add(
                Duration(
                  hours: Random().nextInt(5),
                  minutes: Random().nextInt(59),
                  seconds: Random().nextInt(59)
                )
              ),
              timeTextStyle: TextStyle(
                fontSize: screenWidth/57,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              enableDescriptions: false,
            ),
          ),
          SizedBox(height: screenWidth/280),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


}
