import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/screenAdapter.dart';
import '../utils/storage.dart';

import '../provider/AppProvider.dart';
import 'package:provider/provider.dart';
import '../widget/tag.dart';
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget taskItem({title = '', date = '',tagIndex=0}) {
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
                    SizedBox(height: 5,),
                    Text(date,
                        style: TextStyle(
                            fontSize: ScreenAdapter.setSp(28),
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
                    InkWell(
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.lightBlue,
                      ),
                      onTap: null,
                    ),
                    Text('花费19分钟'),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  var appProvider;
  var temp = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_alarm),
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            Navigator.pushNamed(context, '/addtime');
          },
        ),
        appBar: AppBar(
          title: Text('Todo'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.restore),
            onPressed: () {
              appProvider.taskList = [];
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              onPressed: ()  {
              },
            ),
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/timeline');
              },
              icon: Icon(Icons.timeline),
            )
          ],
        ),
        // body: ListView.builder(
        //         itemCount: appProvider.taskList.length,
        //         itemBuilder: (context,index){

        //           var task = appProvider.taskList;
        //           if(task.length>0){
        //             return taskItem(title:task[index]["title"],date: task[index]["date"]);
        //           }else{
        //             return Text('x');
        //           }
        //         },
        //       ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: Text('未完成',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 36)),
            ),
            appProvider.taskList.length > 0
                ? ListView.builder(
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: appProvider.taskList.length,
                    itemBuilder: (context, index) {
                      var task = appProvider.taskList;
                      return taskItem(
                          title: task[index]["title"],
                          date: task[index]["date"],
                          tagIndex:task[index]["tag"]??0);
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
        )
        // child: Text('plus'),
        // onPressed: () {
        //  
        //
        // },

        // CupertinoActivityIndicator(
        //   animating: true,

        // ),
        );
  }
}
