import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class VirtuoozaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VirtuoozaHomeState();
}

class VirtuoozaHomeState extends State<VirtuoozaHome> {

  // Base URL for our wordpress API
  final String apiUrl = "https://clubedoconsignado.com.br/wp-json/wp/v2/";
  // Empty list for our posts
  List posts;

  // Function to fetch list of posts
  Future<String> getPosts() async {

    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"), headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
      print(resBody);
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/logo_70px.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Container(
                padding: const EdgeInsets.all(15.0), child: Text("Notícias"))
          ],

        ),
      ),
      body:

      ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {

          //var datatrab = DateFormat.yMd("pt_BR").parse(posts[index]["date"]).toString();
          var datatrab = posts[index]["date"];

          return Column(
            children: <Widget>[
              Card(
                color: Colors.deepPurple,
                child: Column(
                  children: <Widget>[
                    new Image.network(posts[index]["_embedded"]["wp:featuredmedia"][0]["source_url"],
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null)
                          return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                                : null,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                        );
                    },
                    color: Colors.deepPurple,
                    colorBlendMode: BlendMode.overlay,
                    ),
                    new Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: Icon(Icons.calendar_today),
                            ),
                            Expanded(
                              child: Text(datatrab),
                            ),
                          ],
                        ),

                    ),

                    new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new ListTile(
                        leading: Icon(Icons.announcement, size: 40.0,),
                        title: new Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                           // child: new Text(posts[index]["date"])),
                            child: new Text(posts[index]["title"]["rendered"])),
                        subtitle: new Text(
                            posts[index]["excerpt"]["rendered"].replaceAll(
                                new RegExp(r'<[^>]*>'), ''
                            )
                        ),
                      ),

                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}