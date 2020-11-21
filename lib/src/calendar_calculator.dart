enum CalendarDayState { normal, selected }

class Day {
  final DateTime date;
  CalendarDayState state = CalendarDayState.normal;

  Day(this.date);
}

extension DescExtension on Day {
  String get desc => this.date.day.toString();
}


class CalendarCalculator {
  final int startYear;
  final int startMonth;
  final int endYear;
  final int endMonth;

  final double itemHeight;
  final double secitonHeaderHeight;

  List<List<Day>> data;

  int _currentMonthSection = 0;

  CalendarCalculator(
      {this.startYear,
      this.startMonth,
      this.endYear,
      this.endMonth,
      this.itemHeight,
      this.secitonHeaderHeight}) {
    int totalMonth = endYear == startYear
        ? (endMonth - startMonth)
        : ((endYear - startYear - 1) * 12 + (12 - startMonth + endMonth + 1));

    DateTime now = DateTime.now();

    data = List.generate(totalMonth, (index) {
      int monthNum = startMonth + index;
      int year = startYear + (monthNum / 12).floor();
      int month = (monthNum % 12 == 0) ? 12 : (monthNum % 12);
      DateTime currentMonth = DateTime.parse("$year${_fullMonthDesc(month)}01");

      if (currentMonth.year == now.year && currentMonth.month == now.month) {
        _currentMonthSection = index;
      }
      int daysInMonth = this.daysInMonth(currentMonth.month, currentMonth.year);

      int startWeekday = this
          .getStartWeekday(year: currentMonth.year, month: currentMonth.month);
      int startSpace = (7 == startWeekday) ? 0 : startWeekday;
      List<Day> days = List.generate(startSpace + daysInMonth, (index) {
        DateTime date = DateTime(currentMonth.year, currentMonth.month, index - startSpace + 1);
        return index < startSpace ? null : Day(date);
      });
      return days;
    });
  }

  int getSectionCount() {
    return data.length;
  }

  int getItemCount({int section}) {
    return data[section].length;
  }

  String getSectionTitle({int section}) {
    int monthNum = startMonth + section;
    int year = startYear + (monthNum / 12).floor();
    int month = (monthNum % 12 == 0) ? 12 : (monthNum % 12);
    DateTime currentMonth = DateTime.parse("$year${_fullMonthDesc(month)}01");
    return "${currentMonth.year}-${this._fullMonthDesc(currentMonth.month)}";
  }

  String getItemDesc({int section, int index}) {
    return data[section][index]?.desc;
  }

  int getStartWeekday({int year, int month}) {
    return DateTime.parse("$year${_fullMonthDesc(month)}01").weekday;
  }

  int sectionRowCount({int section}) {
    int count = data[section].length;
    if (((count % 7) == 0)) {
      return (count / 7).floor();
    } else {
      return (count / 7).floor() + 1;
    }
  }

  double sectionHeight(
      {int section, double itemHeight, double secitonHeaderHeight}) {
    return secitonHeaderHeight + sectionRowCount(section: section) * itemHeight;
  }

  double getInitialScrollOffset(
      {double itemHeight, double secitonHeaderHeight}) {
    double result = 0;
    for (int i = 0; i < _currentMonthSection; i++) {
      double height = sectionHeight(
          section: i,
          itemHeight: itemHeight,
          secitonHeaderHeight: secitonHeaderHeight);
      result += height;
    }
    return result;
  }

  String _fullMonthDesc(int month) {
    return month < 10 ? "0$month" : "$month";
  }

  daysInMonth(int monthNum, int year) {
    List<int> monthLength = new List(12);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true)
      monthLength[1] = 29;
    else
      monthLength[1] = 28;

    return monthLength[monthNum - 1];
  }

  leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0) leapYear = true;

    return leapYear;
  }
}
