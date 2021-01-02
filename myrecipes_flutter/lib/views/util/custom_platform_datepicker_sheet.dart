import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomPlatformDatePickerSheet extends StatefulWidget {
  final initialDate = DateTime.now();
  final firstDate = DateTime(2000);
  final lastDate = DateTime(3000);

  @override
  State<StatefulWidget> createState() => CustomPlatformDatePickerSheetState();
}

class CustomPlatformDatePickerSheetState
    extends State<CustomPlatformDatePickerSheet> {
  DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final setDateButton = PlatformButton(
      child: Text("Ok"),
      onPressed: () => Navigator.of(context).pop(dateTime),
    );
    final title = Text(
      "Plan Meal",
      style: Theme.of(context).textTheme.subtitle1,
    );
    print(Theme.of(context).brightness);
    return Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoActionSheet(title: title, actions: [
              SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    onDateTimeChanged: _onDateChanged,
                    initialDateTime: dateTime,
                  )),
              setDateButton,
            ])
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                title,
                Flexible(
                    child: CalendarDatePicker(
                        initialDate: dateTime,
                        firstDate: widget.firstDate,
                        lastDate: widget.lastDate,
                        onDateChanged: _onDateChanged)),
                setDateButton
              ],
            );
  }

  _onDateChanged(DateTime value) {
    setState(() {
      this.dateTime = value;
    });
  }
}
