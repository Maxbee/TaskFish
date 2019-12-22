
import 'package:flutter/material.dart';
import '../page/TimeLine.dart';
import '../page/Home.dart';
import '../page/AddTime.dart';
import '../page/test.dart';
import '../page/Complete.dart';

// 配置路由
final routes = {
    // '/course': (context, {arguments}) => CoursePage(
    //       arguments: arguments,
    //     )
    // '/home':(context)=> HomePage(),
     '/timeline':(context)=>TimeLine(),
     '/addtime':(context) => AddTimePage(),
     '/test':(context) => TestPage(),
     '/complete':(context) => CompletePage(),
};

var onGenerateRoute=(RouteSettings settings) {
      // 统一处理
      final String name = settings.name; 
      final Function pageContentBuilder = routes[name];
      if (pageContentBuilder != null) {
        if (settings.arguments != null) {
          final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context, arguments: settings.arguments));
          return route;
        }else{
            final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context));
            return route;
        }
      }
};