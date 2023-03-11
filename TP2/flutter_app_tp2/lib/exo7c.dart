import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';

int getEmptyTileIndex(int currentValue) {
  return Random().nextInt(currentValue * currentValue);
}

class Tile {
  Alignment? alignment;
  Tile({this.alignment});

  Widget croppedImageTile(
      double currentValue, int index, int emptyTileIndex, File imageFile) {
    if (index == emptyTileIndex) {
      return Container(color: Colors.transparent);
    }
    if (imageFile.existsSync() && imageFile.lengthSync() > 0) {
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
              child: Image.file(imageFile),
            ),
          ),
        ),
      );
    } else {
      return FittedBox(
        fit: BoxFit.fill,
        child: ClipRect(
          child: Align(
            alignment: alignment!,
            widthFactor: 1 / currentValue,
            heightFactor: 1 / currentValue,
            child: const ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image(
                image: NetworkImage("https://picsum.photos/512"),
              ),
            ),
          ),
        ),
      );
    }
  }
}

List<Widget> createGridTiles(
  int size,
  int columns,
  int emptyIndex,
  File imageFile,
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
        .croppedImageTile(size.toDouble(), i, emptyIndex, imageFile));
  }
  return tiles;
}

class PositionedTilesInGrid extends StatefulWidget {
  const PositionedTilesInGrid({super.key});

  @override
  State<PositionedTilesInGrid> createState() => _PositionedTilesInGridState();
}

class _PositionedTilesInGridState extends State<PositionedTilesInGrid> {
  int _compteur = 0;
  double _currentValue = 4;
  List<Widget> _tiles = [];
  int _emptyTileIndex = -1;
  bool _isStarted = false;
  late File imageFile = File("../assets/image1.jpg");

  final ImagePicker _picker = ImagePicker();
  final List<Map<String, int>> _previousMoves = [];
  int lastMovedTileIndex = -1;
  bool _canCancel = false;

  List<Map<String, int>> oldTileIndexes = [];

  @override
  void initState() {
    super.initState();
    _tiles = createGridTiles(_currentValue.toInt(), _currentValue.toInt(),
        _emptyTileIndex, imageFile);
  }

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from gallery'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      imageFile = File(pickedFile.path);
                      _tiles = createGridTiles(
                        _currentValue.toInt(),
                        _currentValue.toInt(),
                        _emptyTileIndex,
                        imageFile,
                      );
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      imageFile = File(pickedFile.path);
                      _tiles = createGridTiles(
                        _currentValue.toInt(),
                        _currentValue.toInt(),
                        _emptyTileIndex,
                        imageFile,
                      );
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void swipeTile(int index) {
    if (isAdjacent(index, _emptyTileIndex)) {
      setState(() {
        Widget tappedTile = _tiles[index];
        _tiles[index] = _tiles[_emptyTileIndex];
        _tiles[_emptyTileIndex] = tappedTile;

        int? oldEmptyIndex = oldTileIndexes[_emptyTileIndex]['tileIndex'];
        oldTileIndexes[_emptyTileIndex]['tileIndex'] = index;
        oldTileIndexes[index]['tileIndex'] = oldEmptyIndex!;

        var temp = oldTileIndexes[_emptyTileIndex];
        oldTileIndexes[_emptyTileIndex] = oldTileIndexes[index];
        oldTileIndexes[index] = temp;

        _previousMoves.add({
          'empty': _emptyTileIndex,
          'moved': index,
        });
        lastMovedTileIndex = index;
        _emptyTileIndex = index;
        _compteur++;

        if (checkWin()) {
          showWinDialog();
          oldTileIndexes = [];
        }
        _canCancel = true;
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

  void cancelSwipe() {
    if (_previousMoves.isNotEmpty) {
      Map<String, int> previousMove = _previousMoves.removeLast();
      int emptyIndex = previousMove['empty']!;
      int movedIndex = previousMove['moved']!;
      setState(() {
        Widget tappedTile = _tiles[movedIndex];
        _tiles[movedIndex] = _tiles[emptyIndex];
        _tiles[emptyIndex] = tappedTile;
        lastMovedTileIndex = movedIndex;
        _emptyTileIndex = emptyIndex;
        _compteur--;
        if (_previousMoves.isEmpty) {
          _canCancel = false;
        }
      });
    }
  }

  bool checkWin() {
    for (int i = 0; i < _tiles.length; i++) {
      if (oldTileIndexes[i]['tileIndex'] != oldTileIndexes[i]['oldIndex']) {
        return false;
      }
    }
    return true;
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Congratulations!',
          style: TextStyle(color: Color.fromARGB(159, 77, 182, 172)),
        ),
        backgroundColor: Colors.white,
        content: Text('You solved the puzzle in $_compteur moves.',
            style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _emptyTileIndex = getEmptyTileIndex(_currentValue.toInt());
                _tiles = createGridTiles(_currentValue.toInt(),
                    _currentValue.toInt(), _emptyTileIndex, imageFile);
                shuffleTiles();
                Navigator.pop(context);
              });
            },
            child: const Text('Play again',
                style: TextStyle(color: Color.fromARGB(159, 77, 182, 172))),
          ),
        ],
      ),
    );
  }

  void shuffleTiles() {
    int n = _tiles.length;
    int emptyTileIndex = _tiles.indexOf(_tiles[_emptyTileIndex]);
    List<Widget> shuffledTiles = List.from(_tiles);
    for (int i = n - 1; i > 0; i--) {
      int j = Random().nextInt(i + 1);
      Widget temp = shuffledTiles[i];
      shuffledTiles[i] = shuffledTiles[j];
      shuffledTiles[j] = temp;

      if (j == emptyTileIndex) {
        emptyTileIndex = i;
      } else if (i == emptyTileIndex) {
        emptyTileIndex = j;
      }
    }
    for (int i = 0; i < _tiles.length; i++) {
      int oldIndex = _tiles.indexOf(shuffledTiles[i]);
      oldTileIndexes.add({"tileIndex": i, "oldIndex": oldIndex});
    }

    _emptyTileIndex = emptyTileIndex;
    _tiles = shuffledTiles;
    _compteur = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taquin Game'),
        backgroundColor: const Color.fromARGB(159, 77, 182, 172),
      ),
      body: Container(
        color: const Color.fromARGB(76, 77, 182, 172),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                pickImage(),
                if (_isStarted) {_isStarted = !_isStarted}
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromARGB(159, 77, 182, 172),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Choose Image from Gallery or take a picture'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Moves: $_compteur',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                    letterSpacing: 1.2,
                    fontFamily: 'Roboto',
                  ),
                ),
                ElevatedButton(
                  onPressed: _canCancel ? cancelSwipe : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(159, 77, 182, 172),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Icon(Icons.undo),
                ),
              ],
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
                                      imageFile);
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
                                imageFile);
                            shuffleTiles();
                          } else {
                            _tiles = createGridTiles(
                                _currentValue.toInt(),
                                _currentValue.toInt(),
                                _emptyTileIndex,
                                imageFile);
                            _compteur = 0;
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
                                      imageFile);
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
}
