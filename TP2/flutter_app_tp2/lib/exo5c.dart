import 'package:flutter/material.dart';

class Tile {
  Alignment? alignment;

  Tile({this.alignment});

  Widget croppedImageTile(double currentValue) {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment!,
          widthFactor: 1 / currentValue,
          heightFactor: 1 / currentValue,
          child: Image.asset('./assets/image.jpg'),
        ),
      ),
    );
  }
}

class DisplayGridWidget extends StatefulWidget {
  const DisplayGridWidget({super.key});

  @override
  State<DisplayGridWidget> createState() => _DisplayGridWidgetState();
}

class _DisplayGridWidgetState extends State<DisplayGridWidget> {
  double _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure grid'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: createGrid(_currentValue.toInt()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Size:'),
              SizedBox(
                width: 300, // définir la largeur souhaitée pour le slider
                child: Slider(
                  value: _currentValue,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (double value) {
                    setState(() {
                      _currentValue = value;
                    });
                  },
                  label: '${_currentValue.toInt()}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget createGrid(int currentValue) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: currentValue,
      children: List.generate(
        currentValue * currentValue,
        (index) {
          double x = 0;
          double y = 0;
          if (currentValue > 1) {
            x = ((index % currentValue) / (currentValue - 1) * 2) - 1;
            y = ((index ~/ currentValue) / (currentValue - 1) * 2) - 1;
          }
          return Container(
            child: createTileWidgetFrom(
              Tile(alignment: Alignment(x, y)),
            ),
          );
        },
      ),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(_currentValue),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}
