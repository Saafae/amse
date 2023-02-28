import 'package:flutter/material.dart';
import 'main.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPage();
}

class _FilterPage extends State<FilterPage> {
  String selectedFilter = 'All';
  String selectedCategory = 'Action';

  final filterOptions = ['All', 'movies', 'series'];
  final categoryOptions = [
    'Action',
    'Comedy',
    'Drama',
    'Thriller',
    'Science fiction',
    'Fantasy'
  ];

  void handleFilterSelect(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  void handleCategorySelect(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: filterOptions
              .map((option) => GestureDetector(
                    onTap: () => handleFilterSelect(option),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: option == selectedFilter
                            ? const Color.fromARGB(172, 245, 150, 150)
                            : Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontWeight: option == selectedFilter
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: option == selectedFilter
                              ? const Color.fromARGB(255, 203, 47, 12)
                              : const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categoryOptions
                .map((option) => GestureDetector(
                      onTap: () => handleCategorySelect(option),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: option == selectedCategory
                              ? const Color.fromARGB(172, 245, 150, 150)
                              : Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            fontWeight: option == selectedCategory
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: option == selectedCategory
                                ? const Color.fromARGB(255, 203, 47, 12)
                                : const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: SingleChildScrollView(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: filterMedia(selectedFilter, selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>>? data = snapshot.data;
                  return Column(
                    children: [
                      for (int i = 0; i < data!.length; i += 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/${data[i]['name']}.jpg",
                                  fit: BoxFit.contain,
                                  height: 200,
                                  width: 180,
                                ),
                                const SizedBox(height: 8),
                                Text(data[i]['name']),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                            if (i + 1 < data.length)
                              Column(
                                children: [
                                  Image.asset(
                                    "assets/${data[i + 1]['name']}.jpg",
                                    fit: BoxFit.contain,
                                    height: 200,
                                    width: 180,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(data[i + 1]['name']),
                                ],
                              ),
                          ],
                        ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("No media with category!"),
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
