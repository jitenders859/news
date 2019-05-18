import 'package:news/details.dart';
import 'package:news/news.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news/Business.dart';
import 'package:news/Entertainment.dart';
import 'package:news/Health.dart';
import 'package:news/Science.dart';
import 'package:news/Sports.dart';
import 'package:news/Technology.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Color.fromRGBO(8, 6, 6, 1.0)),
        home: DefaultTabController(
            length: 7,
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('News In', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ))
                  ],
                ),

                bottom: TabBar(
                  isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
             indicator: BubbleTabIndicator(
                    indicatorHeight: 25.0,
                    indicatorColor: Colors.red,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab
                  ),
                  tabs: <Widget>[
                    Tab(text: 'Top 20'),
                    Tab(text: 'Business'),
                    Tab(text: 'Sports'),
                    Tab(text: 'Technology'),
                    Tab(text: 'Entertainment'),
                    Tab(text: 'Health'),
                    Tab(text: 'Science'),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Center(child: TopNews(),),
                  Center(child: BusinessNews(),),
                  Center(child: SportsNews(),),
                  Center(child: TechnologyNews(),),
                  Center(child: EntertainmentNews(),),
                  Center(child: HealthNews(),),
                  Center(child: ScienceNews(),),
                  
                   ],
              ),
            )));
  }
}

class TopNews extends StatefulWidget {
  @override
  _TopNewsState createState() => new _TopNewsState();
}

class _TopNewsState extends State<TopNews> {
  final List<NewsCard> _news = <NewsCard>[];

  bool loading = true;

  FetchNews() async {
    var response = await http.get(
         'https://newsapi.org/v2/top-headlines?country=in&apiKey=7f01c190581f4f2cb139125272fc5ffc');

    if (response.statusCode == 200) {
      _news.clear();
      var responseBody = jsonDecode(response.body);

      for (var data in responseBody['articles']) {
        _news.add(new NewsCard(
          title: data['title'],
          description: data['description'],
          url: data['url'],
          urlToImage: data['urlToImage'],
          content: data['content'],
        ));
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    FetchNews();
  }

  Widget UI() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _news[index],
              itemCount: _news.length,
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Center(child: UI()));
  }
}

class NewsCard extends StatelessWidget {
  final String title, description, url, urlToImage, content;

  NewsCard(
      {this.title, this.description, this.url, this.urlToImage, this.content});

  @override
  Widget build(BuildContext context) {
    News news = new News(title, description, url, urlToImage, content);

    final makeListTile = ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new Details(news)));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: Colors.white24),
            ),
          ),
          child: Image(
            height: 60.0,
            width: 80.0,
            fit: BoxFit.cover,
            image: NetworkImage(urlToImage),
          ),
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        trailing: Icon(Icons.keyboard_arrow_right, size: 30.0));
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          height: 110.0,
          child: makeListTile,
        ));
  }
}
