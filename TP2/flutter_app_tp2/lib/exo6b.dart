import 'package:flutter/material.dart';
import 'dart:math';

int getEmptyTileIndex(int currentValue) {
  return Random().nextInt(currentValue * currentValue);
}

class Tile {
  Alignment? alignment;
  Tile({this.alignment});

  Widget croppedImageTile(double currentValue, int index, int emptyTileIndex) {
    Color? containerColor = Colors.teal[300];
    String text = '$index';
    if (index == emptyTileIndex) {
      containerColor = Colors.transparent;
      text = 'Empty';
    }
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Stack(
          children: [
            Align(
              alignment: alignment!,
              widthFactor: 1 / currentValue,
              heightFactor: 1 / currentValue,
              child: Container(
                height: 300,
                width: 300,
                padding: const EdgeInsets.all(8),
                color: containerColor,
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PositionedTilesInGrid extends StatefulWidget {
  const PositionedTilesInGrid({super.key});

  @override
  State<PositionedTilesInGrid> createState() => _PositionedTilesInGridState();
}

class _PositionedTilesInGridState extends State<PositionedTilesInGrid> {
  double _currentValue = 4;
  List<Widget> _tiles = [];
  int _emptyTileIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moving Tiles in Grid'),
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
                width: 300,
                child: Slider(
                  value: _currentValue,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (double value) {
                    setState(() {
                      _currentValue = value;
                      _emptyTileIndex =
                          getEmptyTileIndex(_currentValue.toInt());
                      print("$_emptyTileIndex");
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
    _tiles = List.generate(
      currentValue * currentValue,
      (index) {
        double x = 0;
        double y = 0;
        if (currentValue > 1) {
          x = ((index % currentValue) / (currentValue - 1) * 2) - 1;
          y = ((index ~/ currentValue) / (currentValue - 1) * 2) - 1;
        }
        return createTileWidgetFrom(Tile(alignment: Alignment(x, y)), index);
      },
    );
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      crossAxisCount: currentValue,
      children: _tiles,
    );
  }

  Widget createTileWidgetFrom(Tile tile, int index) {
    return InkWell(
      child: Container(
        child: tile.croppedImageTile(_currentValue, index, _emptyTileIndex),
      ),
      onTap: () {
        print("tapped on tile");
        final int emptyRow = _emptyTileIndex ~/ _currentValue;
        final int emptyCol = _emptyTileIndex % _currentValue.toInt();
        final int tappedRow = index ~/ _currentValue;
        final int tappedCol = index % _currentValue.toInt();
        final int rowDiff = tappedRow - emptyRow;
        final int colDiff = tappedCol - emptyCol;
        final int adjacentIndex =
            _emptyTileIndex + rowDiff * _currentValue.toInt() + colDiff;
        if (rowDiff.abs() + colDiff.abs() == 1 &&
            adjacentIndex >= 0 &&
            adjacentIndex < _tiles.length) {
          setState(() {
            _tiles[_emptyTileIndex] = _tiles[adjacentIndex];
            _tiles[adjacentIndex] = createTileWidgetFrom(
                Tile(alignment: const Alignment(0, 0)), _emptyTileIndex);
            _emptyTileIndex = adjacentIndex;
          });
        }
      },
    );
  }

  /* Widget createTileWidgetFrom(Tile tile, int index) {
    return InkWell(
      child: Container(
          child: tile.croppedImageTile(_currentValue, index, _emptyTileIndex)),
      onTap: () {
        print("tapped on tile");
        setState(() {
          print("$index");
          _tiles.insert(_emptyTileIndex, _tiles.removeAt(index));
          print("${_tiles[index]}");
        });
      },
    );
  } */

  /*  Widget createTileWidgetFrom(Tile tile, int index) {
    return InkWell(
      child: Container(child: tile.croppedImageTile(_currentValue, index)),
      onTap: () {
        print("tapped on tile");
        setState(() {
          print("$index");
          _tiles.insert(5, _tiles.removeAt(index));
          print("${_tiles[index]}");
        });
      },
    );
  } */
}
