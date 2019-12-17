import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter{
  static init(context){
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }

  static height(double height){
    return ScreenUtil.getInstance().setHeight(height);
  }

  static width(double width){
    return ScreenUtil.getInstance().setWidth(width);
  }

  static setSp(double fontSize){
    return  ScreenUtil(allowFontScaling: true).setSp(fontSize);
  }
   
  static  double getWidth(){
    return ScreenUtil.screenWidth;
  }

  static double screenHeight(){
    return ScreenUtil.screenHeight;
  }
}