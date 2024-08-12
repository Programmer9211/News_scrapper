import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:news_app/news_model.dart';
import 'package:news_app/news_reading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String htmlData = "";

  List<NewsModel> newsModelList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHtmlData();
  }

  void getHtmlData() async {
    Uri uri = Uri.parse("https://indianexpress.com/latest-news/");

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

    final listOfNewsArticles = document.getElementsByClassName("articles");

    for (var element in listOfNewsArticles) {
      final titleElement = element.getElementsByClassName("title")[0];

      final aTag = titleElement.getElementsByTagName("a")[0];

      final title = aTag.text;

      final articleLink = aTag.attributes['href'];

      final pTag = element.getElementsByTagName("p")[0];

      final subTitle = pTag.text;

      final imageTag = element.getElementsByTagName("img")[0];

      final imageUrl = imageTag.attributes['src'];

      NewsModel model = NewsModel(
        title: title,
        subtitle: subTitle,
        articleLink: articleLink ?? "",
        imageUrl: imageUrl ?? "",
      );

      newsModelList.add(model);
    }

    print(listOfNewsArticles.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: newsModelList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NewsReadingScreen(
                        model: newsModelList[index],
                      ),
                    ),
                  );
                },
                title: Image.network(newsModelList[index].imageUrl),
                subtitle: Column(
                  children: [
                    Text(
                      newsModelList[index].title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      newsModelList[index].subtitle,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                // trailing: ,
              ),
            );
          }),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   decodeHtmlData();
      // }),
    );
  }
}
