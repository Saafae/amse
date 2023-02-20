import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Transformer une image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentRotateXValue = 0;
  double _currentRotateZValue = 0;
  double _scale = 1.0;
  double _currentScaleValue = 1;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(color: Colors.white),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_currentRotateXValue)
                ..rotateZ(_currentRotateZValue)
                ..rotateY(isChecked ? -pi : 0)
                ..scale(_currentScaleValue),
              child: Image.asset(
                'image.jpg',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('RotateX:'),
              Slider(
                value: _currentRotateXValue,
                max: 2 * pi,
                onChanged: (double value) {
                  setState(() {
                    _currentRotateXValue = value;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('RotateZ:'),
              Slider(
                value: _currentRotateZValue,
                max: 2 * pi,
                onChanged: (double value) {
                  setState(() {
                    _currentRotateZValue = value;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Mirror:'),
              Checkbox(
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Scale:'),
              Slider(
                value: _currentScaleValue,
                max: 10,
                min: 0,
                onChanged: (double value) {
                  setState(() {
                    _currentScaleValue = value;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
