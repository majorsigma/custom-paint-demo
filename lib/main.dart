import 'dart:ui';

import 'package:CustomPaintDemo/button_painter.dart';
import 'package:CustomPaintDemo/custom_shape.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomPaintExample(),
    );
  }
}

class CustomPaintExample extends StatefulWidget {
  @override
  _CustomPaintExampleState createState() => _CustomPaintExampleState();
}

class _CustomPaintExampleState extends State<CustomPaintExample>
    with SingleTickerProviderStateMixin {
  double percentValue = 0.0;
  double newPercentage = 0.0;
  AnimationController _percentValueAnimationController;
  double _height;
  double _width;

  @override
  void initState() {
    super.initState();
    setState(() {
      percentValue = 0.0;
    });
    _percentValueAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 3000),
    )..addListener(() {
        setState(() {
          
          percentValue = lerpDouble(percentValue, newPercentage,
              _percentValueAnimationController.value);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent[200],
        title: Text("Custom Painter Demo"),
      ),
      body: Container(
          child: Stack(
        children: <Widget>[
          CustomPainterExampleWidgets.buildShape(),
          CustomPainterExampleWidgets.buildButtonAnimation(
              height: _height / 2,
              width: _width / 2,
              percentValue: percentValue,
              onPress: () {
                setState(() {
                  percentValue = newPercentage += 10;
                  if (newPercentage > 100.0) {
                    percentValue = 0.0;
                    newPercentage = 0.0;
                  }
                });
              })
        ],
      )),
    );
  }
}

class CustomPainterExampleWidgets {
  static Widget buildShape() {
    return ClipPath(
      clipper: CustomShapeClass(),
      child: Container(
        color: Colors.greenAccent.withOpacity(.7),
      ),
    );
  }

  static Widget buildButtonAnimation(
      {@required double height,
      @required double width,
      @required double percentValue,
      @required Function onPress}) {
    return Center(
      child: Container(
        height: height,
        width: width,
        child: CustomPaint(
          foregroundPainter: ButtonPainter(
            buttonBorderColor: Colors.lightBlue[300].withOpacity(.8),
            progressColor: Colors.red,
            percentage: percentValue,
            width: 8.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.tealAccent,
              shape: CircleBorder(),
              child: Text(
                "Press \n ${percentValue.toInt()}%",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              onPressed: onPress,
            ),
          ),
        ),
      ),
    );
  }
}
