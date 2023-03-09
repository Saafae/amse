import 'package:flutter/material.dart';

class DisplayGridWidget extends StatelessWidget {
  const DisplayGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grid colored'),
          backgroundColor: const Color.fromARGB(159, 77, 182, 172),
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: List.generate(
              9,
              (index) => Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[100 * (index + 1)],
                    child: Center(
                      child: Text(
                        "Tile ${index + 1}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )),
        ));
  }
}
