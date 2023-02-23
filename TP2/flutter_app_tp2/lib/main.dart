import 'package:flutter/material.dart';

import 'exo2.dart' as exo2;
import 'exo2bis.dart' as exo2bis;
import 'exo4.dart' as exo4;
import 'exo5a.dart' as exo5;
import 'exo5b.dart' as exo5b;
import 'exo5c.dart' as exo5c;
import 'exo6a.dart' as exo6a;

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
      subtitle: 'Move 2 tuiles',
      buildFunc: (context) => const exo6a.PositionedTiles()),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: exo.buildFunc),
                        );
                      }));
            }));
  }
}
