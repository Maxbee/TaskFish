import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import '../utils/screenAdapter.dart';
import '../utils/storage.dart';
import '../widget/tag.dart';
import '../provider/AppProvider.dart';
import 'package:provider/provider.dart';
import '../event_bus/EventBus.dart';
import '../widget/BlankToolBarTool.dart';


import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';


// Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
class AddTimePage extends StatefulWidget {
  AddTimePage({Key key}) : super(key: key);

  _AddTimePageState createState() => _AddTimePageState();
}

class _AddTimePageState extends State<AddTimePage> {
  TextEditingController _textController;
  FocusNode blankNode = FocusNode();
  // Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
  var date;
  String text;
  int tag;
  String markText;
  var _time = '';
  FocusNode focusNode;
  _AddTimePageState() {
    this.tag = 0;
  }
  @override
  void initState() {
    // Step1: 响应空白处的焦点的Node
    blankToolBarModel.outSideCallback = focusNodeChange;
    
    super.initState();
    _textController = TextEditingController();
    focusNode = blankToolBarModel.getFocusNodeByController(_textController);
    this.date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    // _textController.text = '准备做点什么';
  }
  // Step2.2: 焦点变化时的响应操作
  void focusNodeChange(){
    setState(() {});
  }

  @override
  void dispose() {
    // Step3: 在销毁页面时取消监听
    blankToolBarModel.removeFocusListeners();
    super.dispose();
  }

  var appProvider;
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
          appBar: AppBar(
            title: Text(this._time),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  if (this.text != null) {
                    var task = {
                      "title": this.text,
                      "date": this.date,
                      "mark": this.markText,
                      "tag": this.tag,
                      "start_time": this._time,
                      "cost_time": 0, //花费的时间
                    };

                    // appProvider.setTaskList(task);
                    var tempString;
                    var currentTaskList;
                    try {
                      tempString = await Storage.getString("taskList");
                      if (tempString == null) {
                        await Storage.setString("taskList", json.encode([]));
                        tempString = await Storage.getString("taskList");
                      } else {
                        currentTaskList =
                            await Storage.parseFromEncode("taskList");
                      }
                    } catch (e) {
                      await Storage.setString("taskList", json.encode([]));
                    }
                    currentTaskList.add(task);//新增任务
                    List reverseCurrentTask = currentTaskList.reversed.toList();//逆序数据
                    await Storage.setString(
                        "taskList", json.encode(reverseCurrentTask));
                    //储存数据

                    var taskListMap = await Storage.parseFromEncode("taskList");
                  }
                  // Fluttertoast.showToast(
                  //     msg: "添加成功",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.CENTER,
                  //     timeInSecForIos: 1,
                  //     backgroundColor: Colors.black54,
                  //     textColor: Colors.white,
                  //     fontSize: 16.0);

                  eventBus.fire(RefreshTaskEvet());
                  // await Storage.setString("taskList", json.encode(tsList));
                  Navigator.pop(context);
                },
              )
            ],
          ),
          body: BlankToolBarTool.blankToolBarWidget(
          context,
          model:blankToolBarModel,
          body: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Color(0xfff3f3f3),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenAdapter.setSp(24)))),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  autofocus: true,
                  maxLines: 8,
                  style: TextStyle(
                      fontSize: ScreenAdapter.setSp(40), wordSpacing: 10),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: ScreenAdapter.setSp(34),
                    ),
                    border: InputBorder.none, //OutlineInputBorder(),
                    // labelText: '做点什么呢？',
                    // filled: true,
                    // fillColor: Color(0xffdddddd),
                  ),
                  controller: _textController,
                  focusNode: this.focusNode,
                  onChanged: (value) {
                    this.text = value;
                  },
                ),
              ),
              InkWell(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: null,
                      ),
                      Text(
                        this.date.toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: <Widget>[
                          TagWidget(
                            0,
                            clk: () {
                              this.tag = 0;
                            },
                          ),
                          TagWidget(
                            1,
                            clk: () {
                              this.tag = 1;
                            },
                          ),
                          TagWidget(
                            2,
                            clk: () {
                              this.tag = 2;
                            },
                          ),
                          TagWidget(
                            3,
                            clk: () {
                              this.tag = 3;
                            },
                          ),
                          TagWidget(
                            4,
                            clk: () {
                              this.tag = 4;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  this._showDate();
                },
              ),

              timePicker()
              // Column(
              //   // crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Container(
              //         padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             Text('备注'),
              //             TextField(
              //               autofocus: false,
              //               decoration: InputDecoration(
              //                 border: InputBorder.none,
              //                 fillColor: Color(0xfff3f3f3),
              //                 filled: true,
              //               ),
              //               onChanged: (value) {
              //                 this.markText = value;
              //               },
              //             )
              //           ],
              //         )),
              //   ],
              // ),
            ],
          ),
          )
          );
      
    
  }

  void _showDate() async {
    var time = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
      lastDate: new DateTime.now().add(new Duration(days: 30)),
    );

    if (time != null) {
      setState(() {
        this.date = time;
        String d = formatDate(time, [yyyy, '-', mm, '-', dd]);
        this.date = d;
      });
    }
  }

  Widget timePicker() {
    return new TimePickerSpinner(
      is24HourMode: true,
      normalTextStyle: TextStyle(
        fontSize: 24,
      ),
      highlightedTextStyle: TextStyle(fontSize: 32, color: Colors.lightBlue),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      onTimeChange: (time) {
        var t = formatDate(time, [H, ':', nn]);
        print(t);
        setState(() {
          _time = t;
        });
      },
    );
  }
}
