import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart' as home;
import 'filter_page.dart' as filter;
import 'favorite_page.dart' as favorite;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: const MenuPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var favoriteMoviesIds = [];
  var favoriteSeriesIds = [];
  TextEditingController textController = TextEditingController();

  Future<List> allFavorites() async {
    favoriteMoviesIds = [];
    favoriteSeriesIds = [];

    await FirebaseFirestore.instance
        .collection("movies")
        .where("favorite", isEqualTo: true)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        favoriteMoviesIds.add(int.parse(doc.id));
      }
    });
    await FirebaseFirestore.instance
        .collection("series")
        .where("favorite", isEqualTo: true)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        favoriteSeriesIds.add(int.parse(doc.id));
      }
    });
    return [favoriteMoviesIds, favoriteSeriesIds];
  }

  void addFavorite(String collection, int index) async {
    try {
      FirebaseFirestore.instance
          .collection(collection)
          .doc('$index')
          .set({"favorite": true}, SetOptions(merge: true));
      if (collection == "movies") {
        favoriteMoviesIds.add(index);
      } else if (collection == "series") {
        favoriteSeriesIds.add(index);
      }
      notifyListeners();
    } on Exception catch (e) {
      print("$e");
    }
  }

  void removeFavorite(String collection, int index) async {
    try {
      print('$favoriteMoviesIds   delete');
      FirebaseFirestore.instance
          .collection(collection)
          .doc('$index')
          .set({"favorite": false}, SetOptions(merge: true));
      if (collection == "movies") {
        favoriteMoviesIds.remove(index);
      } else if (collection == "series") {
        favoriteSeriesIds.remove(index);
      }
      notifyListeners();
    } on Exception catch (e) {
      print("$e");
    }
  }
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

Future<List<Map<String, dynamic>>> filterMedia(
    String media, String category) async {
  List<Map<String, dynamic>> data = [];
  if (media == 'All') {
    print('Holaa $data');

    var snapshotMovies = await FirebaseFirestore.instance
        .collection('movies')
        .where('category', isEqualTo: category)
        .get();
    for (var doc in snapshotMovies.docs) {
      print('$data');
      data.add(doc.data());
    }
    var snapshotSeries = await FirebaseFirestore.instance
        .collection('series')
        .where('category', isEqualTo: category)
        .get();
    for (var doc in snapshotSeries.docs) {
      print('$data');
      data.add(doc.data());
    }
    return data;
  } else {
    var allCollection = FirebaseFirestore.instance
        .collection(media)
        .where('category', isEqualTo: category);
    var querySnapshot = await allCollection.get();
    for (var doc in querySnapshot.docs) {
      data.add(doc.data());
    }
    return data;
  }
}

class Page {
  final Widget? build;
  const Page({this.build});
}

List pages = [
  const Page(build: home.HomePage()),
  const Page(build: filter.FilterPage()),
  const Page(build: favorite.FavoritePage()),
];

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var page = pages[_selectedIndex];

    switch (_selectedIndex) {
      case 0:
        page = page.build;
        print("$_selectedIndex ");
        break;
      case 1:
        page = page.build;
        print("$_selectedIndex ");
        break;
      case 2:
        page = page.build;
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              title: _selectedIndex == 1
                  ? const Text('Filter')
                  : const Text('Favorites'),
            ),
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: 'Filter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(176, 47, 0, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
