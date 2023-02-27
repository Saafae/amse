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
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadMedia('movies'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>>? movies = snapshot.data;
                      return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    SizedBox(
                                      height: 500.0,
                                      width: double.infinity,
                                      child: Stack(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/${movies[index]['name']}.jpg",
                                            height: 500,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 16,
                                            right: 16,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // FAVORIS
                                              },
                                              child: Icon(
                                                movies[index]['favorite']
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(width: 8.0),
                                          Text(
                                            movies[index]['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  'Director: ${movies[index]['director']}'),
                                              const SizedBox(width: 3.0),
                                              Container(
                                                width: 1.0,
                                                height: 40.0,
                                                color: Colors.grey[300],
                                                margin: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                              ),
                                              const Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 3.0),
                                              Text(
                                                  '${movies[index]['rating']}'),
                                            ],
                                          ),
                                          const SizedBox(height: 3.0),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: const Color.fromARGB(
                                                    255, 255, 143, 0)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Text(
                                              '${movies[index]['category']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                              '${movies[index]['description']}',
                                              textAlign: TextAlign.justify),
                                          const SizedBox(height: 3.0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: movies!.length,
                        viewportFraction: 0.8,
                        scale: 0.9,
                      );
                    } else {
                      return const Center(
                        child: Text("No data !!"),
                      );
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadMedia('series'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>>? series = snapshot.data;

                      return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    SizedBox(
                                      height: 500.0,
                                      width: double.infinity,
                                      child: Stack(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/${series[index]['name']}.jpg",
                                            height: 500,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 16,
                                            right: 16,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                //FAVORIS
                                              },
                                              child: Icon(
                                                series[index]['favorite']
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(width: 8.0),
                                          Text(
                                            series[index]['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  'Director: ${series[index]['director']}'),
                                              const SizedBox(width: 3.0),
                                              Container(
                                                width: 1.0,
                                                height: 40.0,
                                                color: Colors.grey[300],
                                                margin: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                              ),
                                              const Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 3.0),
                                              Text(
                                                  '${series[index]['rating']}'),
                                            ],
                                          ),
                                          const SizedBox(height: 3.0),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: const Color.fromARGB(
                                                    255, 255, 143, 0)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Text(
                                              '${series[index]['category']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                              '${series[index]['description']}',
                                              textAlign: TextAlign.justify),
                                          const SizedBox(height: 3.0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: series!.length,
                        viewportFraction: 0.8,
                        scale: 0.9,
                      );
                    } else {
                      return const Center(
                        child: Text("No data !!"),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
