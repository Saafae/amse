import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';

class DisplayImageWidget extends StatefulWidget {
  const DisplayImageWidget({super.key});

  @override
  State<DisplayImageWidget> createState() => _DisplayImageWidgetState();
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
                    "https://via.placeholder.com/350x150",
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
                    "https://via.placeholder.com/350x150",
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
