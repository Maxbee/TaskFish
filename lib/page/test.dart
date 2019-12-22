import 'dart:convert';

import 'package:flutter/material.dart';
import '../utils/storage.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var temp=[];
  @override
  void initState() {
    // TODO: implement initState
    
    this.test();
  }

  test() async{
   var me = await Storage.getString("testData");
   print(me);
   var list =await Storage.parseFromEncode("testData");
   setState(() {
     temp = list;
   });
  }
  @override
  Widget build(BuildContext context) {
    print(temp);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings_backup_restore),
          onPressed: (){
            this.test();
          },
        ),
        title: Text('测试页面'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: (){
                setState(() {
               temp = [];
             });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: ()async{
             await Storage.setString("testData", json.encode([{"title":'xxxxx'},{"title":'xgm'}]));
           
            },
          )
        ],
      ),
      body: Container(
       child: ListView.builder(
         itemCount: temp.length,
         itemBuilder: (context,index){
           return Text('hhh');
         },
       ),
    ),
    );
  }
}