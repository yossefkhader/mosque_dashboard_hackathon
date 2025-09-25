import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:mosque_dashboard/data/userData.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "السلام عليكم",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Text(
                userData['name'],
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "أنت تنشط في",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Text(
                userData['mousque'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: screenWidth / (screenHeight + 100),
              shrinkWrap: true,
              children: [
                _buildPrayerTimerCard(
                    screenWidth, 'حتى موعد الصلاة القادمة', Icons.alarm),
                _buildDashboardCard(
                    screenWidth,
                    'حتى الفعالية القادمة',
                    "${userData['nextEvent'].difference(DateTime.now()).inDays} يوم",
                    Icons.hourglass_top),
                _buildDashboardCard(screenWidth, 'في طاقم المسجد',
                    "${userData['crew']} أشخاص", Icons.people),
                _buildDashboardCard(screenWidth, 'اكملتها في العام الحالي',
                    "${userData['coursesLearnt']} وحدات", Icons.work),
                _buildDashboardCard(screenWidth, 'الميزانية السنوية للفعاليات',
                    "${userData['annualBudget']} ₪", Icons.monetization_on),
                _buildDashboardCard(
                    screenWidth,
                    'من الميزانية تم استخدامها',
                    "${userData['annualBudgetUsage'] * 100}%",
                    Icons.incomplete_circle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      double screenWidth, String title, String value, IconData icon) {
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
          Icon(icon, size: screenWidth / 35, color: Color(0xFFFFD700)),
          SizedBox(height: screenWidth / 100),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth / 57,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenWidth / 280),
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

  Widget _buildPrayerTimerCard(
      double screenWidth, String title, IconData icon) {
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
          Icon(icon, size: screenWidth / 35, color: Color(0xFFFFD700)),
          SizedBox(height: screenWidth / 100),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TimerCountdown(
              format: CountDownTimerFormat.hoursMinutesSeconds,
              endTime: DateTime.now().isAfter(userData['asr'])
                  ? userData['maghrib']
                  : userData['asr'],
              timeTextStyle: TextStyle(
                fontSize: screenWidth / 57,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              enableDescriptions: false,
            ),
          ),
          SizedBox(height: screenWidth / 280),
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
