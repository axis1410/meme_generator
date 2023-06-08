import 'dart:convert';
import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_spinkit.dart';

class TrendingMeme {
  final String title;
  final String url;

  const TrendingMeme({required this.title, required this.url});

  factory TrendingMeme.fromJson(Map<String, dynamic> json) {
    return TrendingMeme(title: json['title'], url: json['url']);
  }
}

Future<List<TrendingMeme>> getTrending() async {
//   final response = await http.get(
//     Uri.parse("https://reddit-meme.p.rapidapi.com/memes/trending"),
//     headers: {
//       'X-RapidAPI-Key': 'a63f7ceecdmsh689d352d848eed6p1d2453jsn2486c63ea51d',
//       'X-RapidAPI-Host': 'reddit-meme.p.rapidapi.com'
//     },
//   );
//   List<dynamic> data = jsonDecode(response.body);

  final String response = await rootBundle.loadString('assets/trending.json');
  await Future.delayed(const Duration(milliseconds: 1000));

  List<dynamic> data = jsonDecode(response);
  List<TrendingMeme> results = [];

  for (var i = 0; i < data.length; i++) {
    final entry = data[i];
    results.add(TrendingMeme.fromJson(entry));
  }
  inspect(results);
  return results;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<TrendingMeme>> memes;

  @override
  void initState() {
    super.initState();
    memes = getTrending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 450,
                child: FutureBuilder(
                  future: memes,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: spinkit,
                      );
                    } else {
                      return Swiper(
                        scale: 0.8,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          TrendingMeme item = snapshot.data![index];

                          return Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 26,
                                    ),
                                  ),
                                  Image.network(item.url),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
