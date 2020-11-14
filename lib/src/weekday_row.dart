import 'package:flutter/material.dart';

class WeekdayRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekdayWidget())) ;
  }

  List<Widget> _weekdayWidget() {
    List<Widget> list = List();
    list.add(_buildDayView("日"));
    list.add(_buildDayView("一"));
    list.add(_buildDayView("二"));
    list.add(_buildDayView("三"));
    list.add(_buildDayView("四"));
    list.add(_buildDayView("五"));
    list.add(_buildDayView("六"));
    return list;
  }

  Widget _buildDayView(String day) {
    return Text(day);
  }
}
