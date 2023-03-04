import 'package:flutter/material.dart';

import 'exo2.dart' as exo2;
import 'exo2bis.dart' as exo2bis;
import 'exo4.dart' as exo4;
import 'exo5a.dart' as exo5;
import 'exo5b.dart' as exo5b;
import 'exo5c.dart' as exo5c;
import 'exo6a.dart' as exo6a;
import 'exo6b.dart' as exo6b;
import 'exo6c.dart' as exo6c;
import 'exo7.dart' as exo7;
import 'exo7b.dart' as exo7b;
import 'exo7c.dart' as exo7c;
import 'exo7d.dart' as exo7d;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MenuPage());
  }
}

class Exo {
  final String title;
  final String? subtitle;
  final WidgetBuilder buildFunc;

  const Exo({required this.title, this.subtitle, required this.buildFunc});
}

List exos = [
  Exo(
      title: 'Exercise 2',
      subtitle: 'Transform an image',
      buildFunc: (context) => const exo2.DisplayImageWidget()),
  Exo(
      title: 'Exercise 2 bis',
      subtitle: 'Transform an image dynamically',
      buildFunc: (context) => const exo2bis.DisplayImageWidget()),
  Exo(
      title: 'Exercise 4',
      subtitle: 'Display tile',
      buildFunc: (context) => const exo4.DisplayTileWidget()),
  Exo(
      title: 'Exercise 5',
      subtitle: 'Grid colored',
      buildFunc: (context) => const exo5.DisplayGridWidget()),
  Exo(
      title: 'Exercise 5 bis',
      subtitle: 'Grid of cripped images',
      buildFunc: (context) => const exo5b.DisplayGridWidget()),
  Exo(
      title: 'Exercise 5 bis\'',
      subtitle: 'Configurable Grid of cripped images',
      buildFunc: (context) => const exo5c.DisplayGridWidget()),
  Exo(
      title: 'Exercise 6',
      subtitle: 'Move 2 tiles',
      buildFunc: (context) => const exo6a.PositionedTiles()),
  Exo(
      title: 'Exercise 6 bis',
      subtitle: 'Move tiles in grid',
      buildFunc: (context) => const exo6b.PositionedTilesInGrid()),
  Exo(
      title: 'Exercise 6 bis\'',
      subtitle: 'Move tiles in configurable grid',
      buildFunc: (context) => const exo6c.PositionedTilesInGrid()),
  Exo(
      title: 'Exercise 7',
      subtitle: 'Taquin Game + change Image from Asset',
      buildFunc: (context) => const exo7.PositionedTilesInGrid()),
  Exo(
      title: 'Exercise 7 bis',
      subtitle: 'Taquin Game + change Image from internet',
      buildFunc: (context) => const exo7b.PositionedTilesInGrid()),
  Exo(
      title: 'Exercise 7 bis\'',
      subtitle:
          'Taquin Game + change Image from Camera/Gallery image_picker for android',
      buildFunc: (context) => const exo7c.PositionedTilesInGrid()),
  Exo(
      title: 'Exercise 7 bis\'',
      subtitle: 'Taquin Game + change Image from desktop image_picker for web',
      buildFunc: (context) => const exo7d.PositionedTilesInGrid()),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TP2'),
        ),
        body: ListView.builder(
            itemCount: exos.length,
            itemBuilder: (context, index) {
              var exo = exos[index];
              return Card(
                  child: ListTile(
                title: Text(exo.title),
                subtitle: Text(exo.subtitle),
                trailing: const Icon(Icons.play_arrow_rounded),
                onTap: () async {
                  if (index == 11) {
                    var result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Hello'),
                          content: const Text(
                              'If you are using Google Chrome to access this exercise, we\'re sorry but it won\'t work because it uses a Flutter plugin for iOS and Android. Please try using an Android emulator instead. Thanks!'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (result == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: exo.buildFunc),
                      );
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: exo.buildFunc),
                    );
                  }
                },
              ));
            }));
  }
}
