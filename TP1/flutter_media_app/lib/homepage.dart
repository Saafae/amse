import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class DisplayImageWidget extends StatefulWidget {
  const DisplayImageWidget({super.key});
  @override
  State<DisplayImageWidget> createState() => _DisplayImageWidgetState();
}

Future<List<Map<String, dynamic>>> loadMedia(String collection) async {
  List<Map<String, dynamic>> data = [];
  if (collection == 'favorites') {
    var allMoviesFavorites = FirebaseFirestore.instance
        .collection('movies')
        .where("favorite", isEqualTo: true);
    var allSeriesFavorites = FirebaseFirestore.instance
        .collection('series')
        .where("favorite", isEqualTo: true);
    var querySnapshotMovies = await allMoviesFavorites.get();
    var querySnapshotSeries = await allSeriesFavorites.get();
    for (var doc in querySnapshotMovies.docs) {
      data.add(doc.data());
    }
    for (var doc in querySnapshotSeries.docs) {
      data.add(doc.data());
    }
    return data;
  } else {
    var allCollection = FirebaseFirestore.instance.collection(collection);
    var querySnapshot = await allCollection.get();
    for (var doc in querySnapshot.docs) {
      data.add(doc.data());
    }
    return data;
  }
}

class _DisplayImageWidgetState extends State<DisplayImageWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.local_movies),
                      SizedBox(width: 8.0),
                      Text('Movies'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.tv),
                      SizedBox(width: 8.0),
                      Text('Series'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    "https://picsum.photos/512/1024",
                    fit: BoxFit.fill,
                  );
                },
                itemCount: 3,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              ),
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    "https://picsum.photos/512/1024",
                    fit: BoxFit.fill,
                  );
                },
                itemCount: 3,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              ),
            ],
          ),
        ));
  }
}
