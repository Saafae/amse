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

List<Widget> createGridTiles(int size, int columns, int emptyIndex) {
  final tiles = <Widget>[];
  var alignment = Alignment(-1 + (2 / columns), -1 + (2 / columns));

  for (int i = 0; i < size * size; i++) {
    tiles.add(Tile(alignment: alignment)
        .croppedImageTile(size.toDouble(), i, emptyIndex));
    alignment += Alignment(2 / columns, 0);
    if ((i + 1) % columns == 0) {
      alignment = Alignment(-1 + (2 / columns), alignment.y + (2 / columns));
    }
  }
  return tiles;
}

class PositionedTilesInGrid extends StatefulWidget {
  const PositionedTilesInGrid({super.key});

  @override
  State<PositionedTilesInGrid> createState() => _PositionedTilesInGridState();
}

class _PositionedTilesInGridState extends State<PositionedTilesInGrid> {
  final double _currentValue = 4;
  List<Widget> _tiles = [];
  int _emptyTileIndex = Random().nextInt(4 * 4);

  @override
  void initState() {
    super.initState();
    _tiles = createGridTiles(
        _currentValue.toInt(), _currentValue.toInt(), _emptyTileIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moving Tiles in Grid'),
        backgroundColor: const Color.fromARGB(159, 77, 182, 172),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              crossAxisCount: _currentValue.toInt(),
              children: _tiles
                  .map((tile) => GestureDetector(
                        onTap: () {
                          swipeTile(_tiles.indexOf(tile));
                        },
                        child: tile,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void swipeTile(int index) {
    if (isAdjacent(index, _emptyTileIndex)) {
      setState(() {
        Widget tappedTile = _tiles[index];
        _tiles[index] = _tiles[_emptyTileIndex];
        _tiles[_emptyTileIndex] = tappedTile;
        _emptyTileIndex = index;
      });
    }
  }

  bool isAdjacent(int index1, int index2) {
    int columnCount = _currentValue.toInt();
    return (index1 % columnCount == index2 % columnCount &&
            (index1 - index2).abs() == columnCount) ||
        (index1 ~/ columnCount == index2 ~/ columnCount &&
            (index1 - index2).abs() == 1);
  }
}
