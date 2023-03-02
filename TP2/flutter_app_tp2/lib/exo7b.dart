import 'package:flutter/material.dart';
import 'dart:math';

int getEmptyTileIndex(int currentValue) {
  return Random().nextInt(currentValue * currentValue);
}

class Tile {
  Alignment? alignment;
  Tile({this.alignment});

  Widget croppedImageTile(
      double currentValue, int index, int emptyTileIndex, String imagePath) {
    if (index == emptyTileIndex) {
      return Container(color: Colors.transparent);
    }
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment!,
          widthFactor: 1 / currentValue,
          heightFactor: 1 / currentValue,
          child: ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.transparent, BlendMode.dst),
            child: Image(
              image: NetworkImage(imagePath),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> createGridTiles(
  int size,
  int columns,
  int emptyIndex,
  String imagePath,
) {
  final tiles = <Widget>[];
  for (int i = 0; i < size * size; i++) {
    double x = 0;
    double y = 0;
    if (columns > 1) {
      x = ((i % columns) / (columns - 1) * 2) - 1;
      y = ((i ~/ columns) / (columns - 1) * 2) - 1;
    }
    final alignment = Alignment(x, y);
    tiles.add(Tile(alignment: alignment)
        .croppedImageTile(size.toDouble(), i, emptyIndex, imagePath));
  }
  return tiles;
}

class PositionedTilesInGrid extends StatefulWidget {
  const PositionedTilesInGrid({super.key});

  @override
  State<PositionedTilesInGrid> createState() => _PositionedTilesInGridState();
}

class _PositionedTilesInGridState extends State<PositionedTilesInGrid> {
  double _currentValue = 4;
  List<Widget> _tiles = [];
  int _emptyTileIndex = -1;
  bool _isStarted = false;
  late String imagePath = "https://picsum.photos/512";

  @override
  void initState() {
    super.initState();
    _tiles = createGridTiles(_currentValue.toInt(), _currentValue.toInt(),
        _emptyTileIndex, imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taquin Game'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(76, 77, 182, 172),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() {
                imagePath =
                    'https://picsum.photos/512?random=${Random().nextInt(100)}';
                _tiles = createGridTiles(_currentValue.toInt(),
                    _currentValue.toInt(), _emptyTileIndex, imagePath);
              }),
              child: const Text('New Image'),
            ),
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
            SizedBox(height: 200, child: Image(image: NetworkImage(imagePath))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _isStarted
                        ? null
                        : (_currentValue > 2
                            ? () => setState(() {
                                  _currentValue--;
                                  _tiles = createGridTiles(
                                      _currentValue.toInt(),
                                      _currentValue.toInt(),
                                      _emptyTileIndex,
                                      imagePath);
                                })
                            : null),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(159, 77, 182, 172),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Icon(Icons.remove),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() {
                          if (!_isStarted) {
                            _emptyTileIndex =
                                getEmptyTileIndex(_currentValue.toInt());
                            _tiles = createGridTiles(
                                _currentValue.toInt(),
                                _currentValue.toInt(),
                                _emptyTileIndex,
                                imagePath);
                            shuffleTiles();
                          } else {
                            _tiles = createGridTiles(
                                _currentValue.toInt(),
                                _currentValue.toInt(),
                                _emptyTileIndex,
                                imagePath);
                          }
                          _isStarted = !_isStarted;
                        }),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              _isStarted ? Colors.red : Colors.green,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24.0),
                        ),
                        child: Text(_isStarted ? 'Stop' : 'Start'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _isStarted
                        ? null
                        : (_currentValue < 10
                            ? () => setState(() {
                                  _currentValue++;
                                  _tiles = createGridTiles(
                                      _currentValue.toInt(),
                                      _currentValue.toInt(),
                                      _emptyTileIndex,
                                      imagePath);
                                })
                            : null),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(159, 77, 182, 172),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateEmptyTileIndex() {
    for (int i = 0; i < _tiles.length; i++) {
      if (_tiles[i] == _tiles[_emptyTileIndex]) {
        _emptyTileIndex = i;
        break;
      }
    }
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

  void shuffleTiles() {
    int n = _tiles.length;
    int emptyTileIndex = _tiles.indexOf(_tiles[_emptyTileIndex]);
    for (int i = n - 1; i > 0; i--) {
      int j = Random().nextInt(i + 1);
      Widget temp = _tiles[i];
      _tiles[i] = _tiles[j];
      _tiles[j] = temp;
      if (j == emptyTileIndex) {
        emptyTileIndex = i;
      } else if (i == emptyTileIndex) {
        emptyTileIndex = j;
      }
    }
    _emptyTileIndex = emptyTileIndex;
  }
}
