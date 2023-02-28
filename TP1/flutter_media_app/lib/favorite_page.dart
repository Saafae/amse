import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadMedia('favorites'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          if (appState.favoriteMoviesIds.isEmpty &&
              appState.favoriteSeriesIds.isEmpty) {
            return const Center(
              child: Text('No favorites yet.'),
            );
          }
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0), // add spacing between rows
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 200,
                              width: 100,
                              child: Image.asset(
                                "assets/${data![index]['name']}.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: const Color.fromARGB(
                                          173, 203, 47, 12)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    '${data[index]['category']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(data[index]['description'],
                                    textAlign: TextAlign.justify),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: IconButton(
                              onPressed: () {
                                if (index >=
                                    appState.favoriteMoviesIds.length) {
                                  appState.removeFavorite(
                                      'series',
                                      appState.favoriteSeriesIds[index -
                                          appState.favoriteMoviesIds.length]);
                                } else {
                                  appState.removeFavorite('movies',
                                      appState.favoriteMoviesIds[index]);
                                }
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              });
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
