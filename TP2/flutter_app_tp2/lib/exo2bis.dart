import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class DisplayImageWidget extends StatefulWidget {
  const DisplayImageWidget({super.key});

  @override
  State<DisplayImageWidget> createState() => _DisplayImageWidgetState();
}

class _DisplayImageWidgetState extends State<DisplayImageWidget> {
  double _currentRotateXValue = 0;
  double _currentRotateZValue = 0;
  double _currentScaleValue = 1;
  bool isChecked = false;
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exo 2 : Transformer une image'),
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
                './assets/image1.jpg',
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
                max: 2,
                onChanged: (double value) {
                  setState(() {
                    _currentScaleValue = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAnimating = !isAnimating;
          });

          if (isAnimating) {
            const d = Duration(milliseconds: 50);
            Timer.periodic(d, animate);
          }
        },
        child:
            isAnimating ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
      ),
    );
  }

  bool _animatedScale = true;
  bool _animatedRotX = true;
  bool _animatedRotZ = true;

  void animate(Timer t) {
    setState(() {
      if (_animatedScale) {
        _currentScaleValue += 0.1;
        if (_currentScaleValue >= 2.0) {
          _currentScaleValue = 2.0;
          _animatedScale = false;
        }
      } else {
        _currentScaleValue -= 0.1;
        if (_currentScaleValue <= 0.0) {
          _currentScaleValue = 0.0;
          _animatedScale = true;
        }
      }

      if (_animatedRotX) {
        _currentRotateXValue += 0.1;
        if (_currentRotateXValue >= 2 * pi) {
          _currentRotateXValue = 2 * pi;
          _animatedRotX = false;
        }
      } else {
        _currentRotateXValue -= 0.1;
        if (_currentRotateXValue <= 0.0) {
          _currentRotateXValue = 0.0;
          _animatedRotX = true;
        }
      }

      if (_animatedRotZ) {
        _currentRotateZValue += 0.2;
        if (_currentRotateZValue >= 2 * pi) {
          _currentRotateZValue = 2 * pi;
          _animatedRotZ = false;
        }
      } else {
        _currentRotateZValue -= 0.2;
        if (_currentRotateZValue <= 0.0) {
          _currentRotateZValue = 0.0;
          _animatedRotZ = true;
        }
      }
    });

    if (!isAnimating) {
      t.cancel();
    }
  }
}
