import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List images;

  @override
  void initState() {
    super.initState();
    this.getJSONData();
  }

  Future<String> getJSONData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://unsplash.com/napi/photos/Q14J2k8VE3U/related"),
        headers: {"Accept": "application/json"});
    var data = response.body;

    setState(() {
      images = json.decode(data)['results'];
    });
    return '';
  }

  Widget imageContainer(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
      ),
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item['urls']['small'],
            placeholder: (context, url) {
              return CircularProgressIndicator();
            },
            errorWidget: (context, url, error) {
              return Icon(Icons.error);
            },
            fadeOutDuration: Duration(seconds: 1),
            fadeInDuration: Duration(seconds: 3),
          ),
          SizedBox(height: 20),
          description(item)
        ],
      ),
    );
  }

  Widget description(dynamic item) {
    return ListTile(
      title: Text(item['description'] == null ? '' : item['description']),
      subtitle: Text(item['likes'] == null ? '0' : item['likes'].toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: images == null ? 0 : images.length,
          itemBuilder: (context, index) {
            return imageContainer(images[index]);
          }),
    );
  }
}
