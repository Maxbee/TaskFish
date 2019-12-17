import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/AppProvider.dart';

class TimeLine extends StatefulWidget {
  TimeLine({Key key}) : super(key: key);

  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  var appProvider;
  @override
  Widget build(BuildContext context) {

    appProvider = Provider.of<AppProvider>(context);
    final List<Step> ls=[];
    var taskList = appProvider.taskList;
    taskList.forEach((item){
      print(item);
      ls.add(
        new Step(
              title: new Text(item["date"]),
              content: new Text(''),
              state: StepState.disabled,
              isActive: true,
              subtitle: new Text(item["title"]),
            )
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('时间线'),
      ),
      body: ListView(
      children: <Widget>[
        Stepper(
          currentStep: 0, // <-- 激活的下标
          steps:ls
        )
      ],
    ),
    );
  }
}
