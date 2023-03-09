import 'package:flutter/material.dart';

class Tile {
  Alignment? alignment;

  Tile({this.alignment});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment!,
          widthFactor: 0.3,
          heightFactor: 0.3,
          child: Image.asset('./assets/image1.jpg'),
        ),
      ),
    );
  }
}

class DisplayGridWidget extends StatelessWidget {
  const DisplayGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grid Cropped Image'),
          backgroundColor: const Color.fromARGB(159, 77, 182, 172),
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(-1, -1)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(0, -1)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(1, -1)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(-1, 0)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(0, 0)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(1, 0)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(-1, 1)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(0, 1)))),
            Container(
                child: createTileWidgetFrom(
                    Tile(alignment: const Alignment(1, 1)))),
          ],
        ));
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}
