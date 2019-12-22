import 'package:flutter/material.dart';

import '../utils/screenAdapter.dart';

List tagColor = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.black
];
class TagWidget extends StatefulWidget {
  int index;
  Object clk;
  var borderColor=Colors.white;
  TagWidget(this.index,{Key key,this.clk,borderColor}) : super(key: key);

  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      child: Container(
        
       width: ScreenAdapter.width(36),
       height: ScreenAdapter.width(36),
       margin: EdgeInsets.only(right: 5),
       decoration: BoxDecoration(
         color: tagColor[widget.index],
         border: Border.all(
           color: widget.borderColor,
           width: 2
         ),
         borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(18)))
       ),
    ),
    onTap: widget.clk,
    );
  }
}