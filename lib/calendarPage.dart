import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'appConsts.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
            'تقويم المسجد',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
          SizedBox(height: 20),
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                allowedViews: [
                  CalendarView.month,
                  CalendarView.week,
                  CalendarView.day,
                  CalendarView.schedule,
                ],
                showNavigationArrow: true,
                showDatePickerButton: true,
                showTodayButton: true,
                
                minDate: DateTime.now().subtract(Duration(days: 365*2)),
                maxDate: DateTime.now().add(Duration(days: 365*2)),
              
                todayTextStyle: AppConsts.secondTitleTextStyle,
                todayHighlightColor: AppConsts.secondaryColor,
                cellBorderColor: Colors.white,
                // backgroundColor: Color.fromRGBO(89, 153, 98, 1),
                backgroundColor: AppConsts.primaryColor,
              
                selectionDecoration: _selectionDecoration(),
                monthViewSettings: _monthView(),
                headerStyle: _headerStyle(),
                viewHeaderStyle: _viewHeaderStyle(),
                timeSlotViewSettings: _timeTlotViewSettings(),
              ),
            ),
          ],
        ),
      );
  }

  BoxDecoration _selectionDecoration() => BoxDecoration(
    color: Colors.transparent,
    border: Border.all(
      color: AppConsts.secondaryColor, 
      width: 2
    ),
    borderRadius: const BorderRadius.all(Radius.circular(4)),
    shape: BoxShape.rectangle,
  );

  MonthViewSettings _monthView() => MonthViewSettings(
    monthCellStyle: MonthCellStyle(
      textStyle: AppConsts.bodyTextStyle,
      trailingDatesBackgroundColor: Color.fromARGB(255,37, 63, 40),
      leadingDatesBackgroundColor: Color.fromARGB(255,37, 63, 40),
      trailingDatesTextStyle: AppConsts.trailingTextStyle,
      leadingDatesTextStyle: AppConsts.trailingTextStyle,
    )
  );

  CalendarHeaderStyle _headerStyle() => CalendarHeaderStyle(
    textAlign: TextAlign.center,
    backgroundColor: AppConsts.primaryColor,
    textStyle: TextStyle(
      fontStyle: FontStyle.normal,
      color: Color(0xFFffeaea),
      fontWeight: FontWeight.w500
    ),
  );

  ViewHeaderStyle _viewHeaderStyle() => ViewHeaderStyle(
    dayTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500
        ),
    dateTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500
        )
  );

  TimeSlotViewSettings _timeTlotViewSettings() =>TimeSlotViewSettings(
    timeInterval: Duration(hours: 2), 
    timeFormat: 'HH:mm', //24h format
    timeTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: Colors.white,
    )
  );  

}