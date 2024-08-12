import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:news_app/news_model.dart';

class NewsReadingScreen extends StatefulWidget {
  final NewsModel model;
  const NewsReadingScreen({super.key, required this.model});

  @override
  State<NewsReadingScreen> createState() => _NewsReadingScreenState();
}

class _NewsReadingScreenState extends State<NewsReadingScreen> {
  String htmlData = "";
  String articleContent = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHtmlData();
  }

  void getHtmlData() async {
    Uri uri = Uri.parse(widget.model.articleLink);

    final result = await http.get(uri);

    if (result.statusCode == 200 || result.statusCode == 201) {
      print(result.body);

      htmlData = result.body;

      decodeHtmlData();

      setState(() {});
    } else {
      print("Something went wrong");
    }
  }

  void decodeHtmlData() async {
    final document = html.parse(htmlData);

    final articleDescription = document.getElementsByClassName("main-story")[0];

    final pTags = articleDescription.getElementsByTagName("p");

    for (var element in pTags) {
      articleContent = articleContent + element.text;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                widget.model.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Image.network(
                widget.model.imageUrl,
              ),
              SizedBox(
                height: 20,
              ),
              Text(articleContent),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   decodeHtmlData();
        // }),
      ),
    );
  }
}
