import 'dart:async';
import 'dart:convert';

import 'package:flui/widgets/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/screenAdapter.dart';
import '../utils/storage.dart';

import '../provider/AppProvider.dart';
import 'package:provider/provider.dart';
import '../widget/tag.dart';
import '../event_bus/EventBus.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentTimer; //当前的timer
  int currenRecorderIndex; //当前记时的项目索引
  var cost_time = 0;

  var appProvider;
  var temp = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<RefreshTaskEvet>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      this.intiDo();
    });

    this.intiDo();
    
  }

  intiDo() async {
    var tempString;
    var currentTaskList;
    try {
      tempString = await Storage.getString("taskList");
      if (tempString == null) {
        await Storage.setString("taskList", json.encode([]));
        tempString = await Storage.getString("taskList");
      } else {
        currentTaskList = await Storage.parseFromEncode("taskList");
      }
    } catch (e) {
      await Storage.setString("taskList", json.encode([]));
    }

    setState(() {
      temp = currentTaskList;
    });
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    ScreenAdapter.init(context);
    // print("temp>0?${temp.length}");
    // print("temp>0?${temp}");

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_alarm),
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            Navigator.pushNamed(context, '/addtime');
          },
        ),
        appBar: AppBar(
          title: Text('Todo'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.restore),
            onPressed: () async {
              this._showBottonModal();
              return;
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.inbox,
                // color: Colors.white,
              ),
              onPressed: ()  {
                // Navigator.pushNamed(context, '/test');
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/timeline');
              },
              icon: Icon(Icons.timeline),
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: Text('未完成',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenAdapter.setSp(50))),
            ),
            temp.length > 0
                ? ListView.builder(
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: temp.length,
                    itemBuilder: (context, index) {
                      var task = this.temp;
                      // print(index.runtimeType);
                      print("task${task}");

                      return InkWell(
                        // hoverColor: Colors.transparent,
                        // splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: this.taskItem(
                            title: task[index]["title"],
                            date: task[index]["date"],
                            tagIndex: task[index]["tag"],
                            costTime: task[index]["cost_time"],
                            starTime: task[index]["start_time"],
                            index: index),
                        onLongPress: () {
                          
                          showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('删除第${index+1}条项目？'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('老哥，删除的项目不能恢复哦！'),
                                       
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('确定'),
                                      onPressed: () {
                                        this._deletTaskFromIndex(index);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('取消',style: TextStyle(color: Colors.red)),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                          
                        },
                      );
                    },
                  )
                : Center(
                    child: Text('暂无待办',
                        style: TextStyle(
                            color: Color(0xffcccccc),
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ),
          ],
        ));
  }

  Widget taskItem(
      {title = '', date = '', tagIndex = 0, costTime, starTime, index}) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: BoxDecoration(
            color: Color(0xfff3f3f3),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: ScreenAdapter.setSp(36),
                          color: Color(0xff333333)),
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${date}   ${starTime}",
                        style: TextStyle(
                            fontSize: ScreenAdapter.setSp(26),
                            color: Color(0xff999999))),
                    SizedBox(height: 5),
                    TagWidget(tagIndex),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    this.currenRecorderIndex == index
                        ? IconButton(
                            icon: Icon(
                              Icons.pause,
                              color: Colors.lightBlue,
                            ),
                            onPressed: () {
                              this._recorderTime();
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.play_circle_filled,
                              color: Colors.lightBlue,
                            ),
                            onPressed: () {
                              setState(() {
                                this.currenRecorderIndex = index;
                              });

                              var i = 0;
                              currentTimer =
                                  Timer.periodic(Duration(seconds: 1), (timer) {
                                setState(() {
                                  this.cost_time = i++;
                                });

                                print(i++);
                              });
                              //  showFLBottomSheet(
                              //       context: context,
                              //         builder: (BuildContext context) {
                              //           return FLCupertinoActionSheet(
                              //             child: Text('${i}'),
                              //           );
                              //       });
                            },
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('花费${costTime}秒'),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //记录时间
  _recorderTime() async {
    var taskList = await Storage.parseFromEncode("taskList");
    taskList[this.currenRecorderIndex]["cost_time"] = this.cost_time;
    // print('${taskList[this.currenRecorderIndex]["cost_time"]}==${taskList}---');
    await Storage.setString("taskList", json.encode(taskList));

    currentTimer.cancel();
    this.intiDo();
    setState(() {
      currenRecorderIndex = -1;
    });
  }
  //删除任务
  _deletTaskFromIndex(int index) async {
    var tasklist = await Storage.parseFromEncode("taskList");
    tasklist.removeAt(index);
    this._addDoneTask(index);//储存已完成的任务区
    await Storage.setString("taskList", json.encode(tasklist));
    this.intiDo();
  }
  //添加完成的任务
  _addDoneTask(index) async{

    var done =await Storage.parseFromEncode("doneTask");
    if(done !=null){
      done = [];
    }
    var taskSingleItem =  await Storage.parseFromEncode("taskList");
    done.add(taskSingleItem[index]);
    await Storage.setString("doneTask", done);
  }

  _showBottonModal() {
    showFLBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FLCupertinoActionSheet(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '一旦清除数据，将无法恢复数据，确定要清除吗?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            cancelButton: CupertinoActionSheetAction(
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Text(
                      '确定',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      //清除数据
                      //appProvider.setTaskAll([]);
                      var taskListStorage = [];
                      await Storage.setString(
                          "taskList", json.encode(taskListStorage));
                      eventBus.fire(RefreshTaskEvet());
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: Text('取消'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              onPressed: () {},
            ),
          );
        }).then((value) {
      print(value);
    });
  }
}
