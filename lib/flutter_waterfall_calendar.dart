library flutter_waterfall_calendar;

import 'package:flutter/material.dart';
import 'package:flutter_waterfall_calendar/src/calendar_calculator.dart';

import 'src/weekday_row.dart';

class WaterfallCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WaterfallCalendarState();
}

class _WaterfallCalendarState extends State<WaterfallCalendar> {

  DateTime selectedBegin;
  DateTime selectedEnd;

  CalendarCalculator calculator;

  ScrollController controller;
  @override
  void initState() {
    calculator = CalendarCalculator(
        startYear: 2000, startMonth: 1, endYear: 2050, endMonth: 12);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      double width = MediaQuery.of(context).size.width - 20;
      double itemHeight = width / 7;

      double initialScrollOffset = calculator.getInitialScrollOffset(
          itemHeight: itemHeight, secitonHeaderHeight: 32);
      controller = ScrollController(initialScrollOffset: initialScrollOffset);
    }

    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(children: [
          WeekdayRow(),
          Expanded(
              child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  // addAutomaticKeepAlives: true,
                  itemCount: calculator.getSectionCount(),
                  itemExtent: 370,
                  cacheExtent: 300,
                  itemBuilder: (context, index) {
                    return buildMonthView(index);
                  }))
        ]));
  }

  Widget buildMonthView(int section) {
    return Column(children: [
      Container(
        height: 32,
        child: Container(
            alignment: Alignment.centerLeft,
            child: Text(calculator.getSectionTitle(section: section))),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
        itemCount: calculator.getItemCount(section: section),
        itemBuilder: (context, index) {
          return Container(
              height: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.all(1),
              color: Colors.yellow,
              child: Text(
                  calculator.getItemDesc(section: section, index: index) ?? "",
                  textAlign: TextAlign.center));
        },
      )
    ]);
  }
}
