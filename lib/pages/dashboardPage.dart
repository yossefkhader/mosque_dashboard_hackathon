import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:mosque_dashboard/data/userData.dart';
import 'package:mosque_dashboard/appConsts.dart';

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
              color: AppConsts.secondaryColor,
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
                  color: AppConsts.textColorPrimary,
                ),
              ),
              SizedBox(width: 15),
              Text(
                userData['name'],
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppConsts.textColorPrimary,
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
                  color: AppConsts.textColorSecondary,
                ),
              ),
              SizedBox(width: 15),
              Text(
                userData['mousque'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppConsts.textColorPrimary,
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
        color: AppConsts.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConsts.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: screenWidth / 35, color: AppConsts.secondaryColor),
          SizedBox(height: screenWidth / 100),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth / 57,
              fontWeight: FontWeight.bold,
              color: AppConsts.textColorPrimary,
            ),
          ),
          SizedBox(height: screenWidth / 280),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppConsts.textColorTertiary,
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
        color: AppConsts.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConsts.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: screenWidth / 35, color: AppConsts.secondaryColor),
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
                color: AppConsts.textColorPrimary,
              ),
              enableDescriptions: false,
            ),
          ),
          SizedBox(height: screenWidth / 280),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppConsts.textColorTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
