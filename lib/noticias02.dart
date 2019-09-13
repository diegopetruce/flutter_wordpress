import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:flare_flutter/flare_actor.dart';


class VirtuoozaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VirtuoozaHomeState();
}

class VirtuoozaHomeState extends State<VirtuoozaHome> {
  // Base URL for our wordpress API
  String apiUrl = "https://clubedoconsignado.com.br/wp-json/wp/v2/";
  final String apiCat =
      "https://clubedoconsignado.com.br/wp-json/wp/v2/categories";
  // Empty list for our posts
  List posts;

  List categorias;
  List catposts;
  var categorySelected = 0;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed=1"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
      print(resBody);
    });
    timeago.setLocaleMessages("pt_br", timeago.PtBrMessages());

    return "Success!";
  }

  Future<String> getPostsFilt() async {
    var res = await http
        .get(Uri.encodeFull(apiUrl), headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });
    timeago.setLocaleMessages("pt_br", timeago.PtBrMessages());

    return "Success!";
  }

  Future<String> getCat() async {
    var res = await http
        .get(Uri.encodeFull(apiCat), headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      categorias = resBody;
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
    this.getCat();
  }

  Future<Null> _refresh() async {
    apiUrl = "https://clubedoconsignado.com.br/wp-json/wp/v2/";
    await this.getPosts();
    await this.getCat();

    return null;
  }

  Widget _getListCategory() {
    ListView listCategory = new ListView.builder(
        itemCount: categorias.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildCategoryItem(index);
        });

    return new Container(
      height: 55.0,
      child: listCategory,
    );
  }

  Widget _buildCategoryItem(index) {
    return new GestureDetector(
      onTap: () {
        onTabCategory(index);
      },
      child: new Center(
        child: new Container(
          margin: new EdgeInsets.only(left: 10.0),
          child: new Material(
            elevation: 10.0,
            borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
            child: new Container(
              padding: new EdgeInsets.only(
                  left: 12.0, top: 7.0, bottom: 7.0, right: 12.0),
              color: categorySelected == index
                  ? Colors.deepPurple[800]
                  : Colors.deepPurple,
              child: new Text(
                categorias[index]["name"],
                style: new TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onTabCategory(index) {
    setState(() {
      categorySelected = index;
      var cat = categorias[index]["id"];
      apiUrl =
          "https://clubedoconsignado.com.br/wp-json/wp/v2/posts?_embed=1&categories=$cat";
      print(apiUrl);
      this.getPostsFilt();
    });

    //Realiza chamada de serviço para atualizar as noticias de acordo com a categoria selecionada
  }

  gotoview(index) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: new AppBar(
          backgroundColor: Colors.deepPurple,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/logo_70px.png',
                fit: BoxFit.contain,
                height: 40,
              ),
            ],
          ),
        ),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Material(
            elevation: 4.0,
            borderRadius: new BorderRadius.circular(6.0),
            child: new ListView(
              children: <Widget>[
                Container(
                    height: 200.0,
                    child: new Image.network(
                        posts[index]["_embedded"]["wp:featuredmedia"][0]
                            ["media_details"]["sizes"]["medium"]["source_url"],
                        fit: BoxFit.cover)),
                Container(
                  margin: new EdgeInsets.all(15.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        posts[index]["title"]["rendered"],
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      Container(
                          margin: new EdgeInsets.only(top: 5.0),
                          child: new Text(
                            timeago.format(DateTime.parse(posts[index]["date"]),
                                locale: 'pt_br'),
                            style: new TextStyle(
                                fontSize: 10.0, color: Colors.grey),
                          )),
                      Container(
                        margin: new EdgeInsets.only(top: 20.0),
                        child: new Text(posts[index]["content"]["rendered"]),
                            /*.replaceAll(new RegExp(r'<[^>]*>'), '').replaceAll(RegExp('&nbsp;'), ''))*/
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }

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
      body: RefreshIndicator(
        color: Colors.white,
        //size: 50.0,
        backgroundColor: Colors.deepPurple,
        onRefresh: _refresh,
        child:
            ListView(physics: const AlwaysScrollableScrollPhysics(), children: <
                Widget>[
          _getListCategory(),
          Center(
            child: SizedBox.fromSize(
              size: const Size.fromHeight(480.0),
              child: PageView.builder(
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: posts == null ? 0 : posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(30.0),
                        child: GestureDetector(
                          onTap: () {
                            gotoview(index);
                          },
                          child: Stack(
                            // borderRadius: BorderRadius.circular(30.0),
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                posts[index]["_embedded"]["wp:featuredmedia"][0]
                                        ["media_details"]["sizes"]["medium"]
                                    ["source_url"],
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.bottomCenter,
                                    end: FractionalOffset.topCenter,
                                    colors: [
                                      const Color(0xBB673ab7),
                                      const Color(0x00000000),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20.0,
                                left: 22.0,
                                right: 22.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        //child: Text("$index"),
                                        ),
                                    Container(
                                      child: Text(
                                        posts[index]["title"]["rendered"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.0,
                                          fontSize: 16.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Text(
                                          posts[index]["excerpt"]["rendered"]
                                              .replaceAll(
                                                  new RegExp(r'<[^>]*>'), '')
                                              .replaceAll(
                                                  RegExp('&#8230;'), '...'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w100,
                                            fontSize: 11.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 18,
                                              height: 18,
                                              child: FlareActor(
                                                'lib/assets/ClubeC.flr',
                                                animation: 'Spin',
                                              ),
                                            ),
                                            Text(
                                              "  " +
                                                  timeago.format(
                                                      DateTime.parse(
                                                          posts[index]["date"]),
                                                      locale: 'pt_br'),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}
