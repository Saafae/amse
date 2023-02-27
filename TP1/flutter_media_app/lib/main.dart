import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'homepage.dart' as home;
import 'filterPage.dart' as filter;
import 'favoritePage.dart' as favorite;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MenuPage());
  }
}

class Page {
  final Widget? build;
  const Page({this.build});
}

List pages = [
  const Page(build: home.DisplayImageWidget()),
  const Page(build: filter.PositionedTiles()),
  const Page(build: favorite.PositionedTiles()),
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
