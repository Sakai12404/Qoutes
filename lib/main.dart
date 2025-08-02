import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Qoutes());
  }
}

class Qoutes extends StatefulWidget {
  const Qoutes({super.key});
  @override
  State<Qoutes> createState() => _Qoutes();
}

class _Qoutes extends State<Qoutes> {
  String qoute = '';
  bool isFavorite = false;
  String author = '';
  List<String> qoutes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Qoute generator")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() => isFavorite = !isFavorite);
                  },
                  icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                ),
                Center(child: Column(children: [Text(qoute), Text(author)]),),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: FloatingActionButton.small(
        onPressed: loadQoute,
        child: const Icon(Icons.new_label_sharp),
      ),
    );
  }

  Future<void> loadQoute() async {
    List<String> info = await getQoute();
    setState(() {
      if (isFavorite) qoutes.add(qoute);
      qoute = info[0];
      author = info[1];
      isFavorite = false;
    });
  }
}

Future<List<String>> getQoute() async {
  Uri url = Uri.parse('https://zenquotes.io/api/quotes/');
  if (kIsWeb) {
    url = Uri.parse('https://corsproxy.io/?https://zenquotes.io/api/quotes/');
  }
  try {
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    //print(data);
    return [data[0]['q'], data[0]['a']];
  } catch (e) {
    return ["Request Failed: $e", "N/A"];
  }
}
