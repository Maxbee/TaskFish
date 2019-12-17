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

class AddTimePage extends StatefulWidget {
  AddTimePage({Key key}) : super(key: key);

  _AddTimePageState createState() => _AddTimePageState();
}

class _AddTimePageState extends State<AddTimePage> {
  TextEditingController _textController;

  var date;
  String text;
  int tag;
  String markText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController(text: '准备做点什么!');
    this.date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    // _textController.text = '准备做点什么';
  }

  var appProvider;
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('增加时间'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (this.text != null) {
                  var task = {
                    "title": this.text,
                    "date": this.date,
                    "mark": this.markText,
                    "tag": this.tag
                  };

                  appProvider.setTaskList(task);
                }
                Fluttertoast.showToast(
                    msg: "添加成功",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 16.0);
                // await Storage.setString("taskList", json.encode(tsList));
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color(0xfff3f3f3),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenAdapter.setSp(24)))),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                autofocus: false,
                maxLines: 8,
                style: TextStyle(
                    fontSize: ScreenAdapter.setSp(40), wordSpacing: 10),
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: ScreenAdapter.setSp(34)),
                  border: InputBorder.none, //OutlineInputBorder(),
                  labelText: '做点什么呢？',
                  // filled: true,
                  // fillColor: Color(0xffdddddd),
                ),
                controller: _textController,
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
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('备注'),
                        TextField(
                          autofocus: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f3),
                            filled: true,
                          ),
                          onChanged: (value) {
                            this.markText = value;
                          },
                        )
                      ],
                    )),
              ],
            ),
          ],
        ));
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
}
