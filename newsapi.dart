import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<StatefulWidget> createState() => _NewsPage();
}

class _NewsPage extends State<NewsPage> {

  Future<dynamic> fetchNews() async {
    String _url=""; //Paste your URL in Double Quotes. Note your URL must follow the same format show in the description.
    /*
    URL:https://gnews.io/api/v4/top-headlines?token=YOUR_API_KEY&lang=en&country=in
    In the URl, In place of "YOUR-API-KEY", you have to enter your API of GNews. If don't have you can 
    generate it from Official Site:- https://gnews.io/
    */
    final url = Uri.parse(
      _url
    );
   
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data.containsKey('articles')) {
        return data['articles'];
      } else {
        throw Exception("API returned error: ${data['errors']}");
      }
    } else {
      throw Exception("Failed with status: ${response.statusCode}");
    }
  }

  late bool isOnline;
  late List<String> title;
  late List<String> content;
  late List<String> imageUrl;
  late List<String> linkUrl;
  var data = Future.value();

  void addDataToList(var data) {
    if (data != null) {
      for (var a in data) {
        title.add(a['title']);
        content.add(a['description']);
        imageUrl.add(a['image']);
        linkUrl.add(a['url']);
      }
    }
  }

  void checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = (connection[0] != ConnectivityResult.none);
      print("checkConnetivity() connection=$connection");
      print("checkConnectivity()=> $isOnline");
      if (isOnline) {
        data = fetchNews();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    title = [];
    content = [];
    imageUrl = [];
    linkUrl = [];
    isOnline=false;

    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((connection) {
      print("initState()=> $connection");

      setState(() {
        isOnline = (connection[0] != ConnectivityResult.none);
        if (isOnline) {
          data = fetchNews();
        }
      });

      print("initState() => isOnline=$isOnline");
    });
  }

  Widget showNoInternetDialogBox(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fintrack-Today's News")),
      body: Center(
        child: AlertDialog(
          title: Text("No Internet", style: TextStyle(fontSize: 22)),
          content: Text("Please, Check your Internet Connection."),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  initState();
                });
              },
              child: Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isOnline) {
      return newsApp();
    }
    return showNoInternetDialogBox(context);
  }

  Widget newsApp() {
    return FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(
            "snapshot.error is executed in build(BuildContext context) => FutureBuilder()",
          );
          return Center(child: Text("Sorry, Some issue might be occured."));
        } else {
          var articles = snapshot.data!;
          addDataToList(articles);
          return Scaffold(
            appBar: AppBar(
              title: Text("Today's News", textAlign: TextAlign.center),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        data = fetchNews();
                      });
                    },
                    child: Icon(Icons.refresh),
                  ),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(7),
                  // height: 100,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  child: _listofNews(index),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _listofNews(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => _eachNewsPage(index),
          ),
        );
      },
      child: ListTile(
        leading: Text("${index + 1}."),
        title: Text(title[index]),
        trailing: Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  Widget _eachNewsPage(int index) {
    String url = imageUrl[index];
    var heading = title[index];
    var news = content[index];
    var link = linkUrl[index];
    Uri uri = Uri.parse(link);

    return Scaffold(
      appBar: AppBar(title: Text(heading)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(15),
              child: Image.network(
                url,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 250,
                errorBuilder: (context, error, stackrace) {
                  return Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "No Image Available",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Text(
                  news,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(32, 32, 32, 1),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("For more Details,"),
                  InkWell(
                    onTap: () async {
                      await launchUrl(uri, mode: LaunchMode.inAppWebView);
                    },
                    child: Text(
                      "visit ${uri.host}",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
