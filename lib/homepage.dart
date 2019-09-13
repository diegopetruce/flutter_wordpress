import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark
      ),
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final TextStyle topMenuStyle = new TextStyle(fontFamily: 'Avenir next', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(fontFamily: 'Avenir next', fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600);



  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        'https://promosys.com.br/videos/13.mp4');
    _videoPlayerController2 = VideoPlayerController.network(
        'https://promosys.com.br/videos/11.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 16/ 9,
      autoPlay: false,
      looping: true,
      //mute: true,


      // Try playing around with some of these other options:

      // showControls: false,
       materialProgressColors: ChewieProgressColors(
         playedColor: Colors.deepPurple[700],
         handleColor: Colors.deepPurple,
         backgroundColor: Colors.black54,
         bufferedColor: Colors.deepPurple,
       ),
       placeholder: Container(
         color: Colors.black87,
       ),
       autoInitialize: true,
    );
    _videoPlayerController2.setVolume(0.0);
    _videoPlayerController1.setVolume(0.0);
    //SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Container(
        // color: Colors.red,
          child: Center(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 430,
                  // color: Colors.blue,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("lib/assets/starwars1.jpg"),
                        fit: BoxFit.fitHeight
                    ),
                  ), // we can change to be backgroundimage instead
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                height: 30,
                                width: 30,
                                child: Image(
                                  image: AssetImage("lib/assets/logo_70px.png"),
                                )
                            ),
                            /*FlatButton(
                              onPressed: (){},
                              child: Text('Series', style: topMenuStyle,),
                            ),
                            FlatButton(
                              onPressed: (){},
                              child: Text('Films', style: topMenuStyle,),
                            ),
                            FlatButton(
                              onPressed: (){},
                              child: Text('My List', style: topMenuStyle,),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child:
                  Stack(
                    //fit: StackFit.expand,
                    children: <Widget>[
                      Chewie(
                        controller: _chewieController,
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
                      Container(
                        margin: EdgeInsets.all(50.0),
                        child: Image.asset("/lib/assets/logo_70px.png"),
                      )

                    ],
                  )

                ),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.add, color: Colors.white, size: 30),
                            Text('My List', style: buttonInfoStyle,)
                          ],
                        ),
                        onPressed: () {

                        },
                      ),
                      FlatButton(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.play_arrow, color: Colors.black,
                            ),
                            Text("Play", style: TextStyle(color: Colors.black),)
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _chewieController.dispose();
                            _videoPlayerController2.pause();
                            _videoPlayerController2.setVolume(0.0);
                            _videoPlayerController2.seekTo(Duration(seconds: 0));
                            _chewieController = ChewieController(
                              videoPlayerController: _videoPlayerController1,
                              aspectRatio: 16/9,
                              autoPlay: true,
                              looping: true,
                            );
                          });
                        },
                      ),
                      FlatButton(
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.info, color: Colors.white, size: 30,),
                            Text('Info', style: buttonInfoStyle,)
                          ],
                        ),
                        onPressed: () {

                        },
                      )
                    ],
                  ),
                ),
                makePopularWidget("Popular on Netflix"),
                makePopularWidget("Trending Now"),
                makeContinueWatching("Continue Watching for Kalle"),
                bannerMovie(),
                makeNetflixOrig('NETFLIX ORIGINALS >'),
                makePopularWidget("Watch It Again"),
                makePopularWidget("New Releases"),
                makePopularWidget("US Crime TV Programmes"),
                makePopularWidget("American Programmes"),
                makePopularWidget("Comedies"),
                makePopularWidget("Romance Programmes"),
                makePopularWidget("US Dysfunctional-family TV Programmes"),
                makePopularWidget("European Films & Programmes"),
                makePopularWidget("US Teen TV Programmes"),
                makePopularWidget("Top Picks For Kalle"),
                makePopularWidget("Documentaries"),
                makePopularWidget("US TV Drama"),
                makePopularWidget("Emotional Crime TV Programmes"),
                makePopularWidget("Ensemble TV Programmes"),
              ],
            ),
          )
      ),
    );
  }

  Widget bannerMovie() {
    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text('Avalable Now', style: topMenuStyle,),
          ),
          Container(child: Image(
            image: new AssetImage("lib/assets/birdboxBanner.jpg"),
          ),),
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    width: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.play_arrow, color: Colors.black,),
                        Text('Play', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                  color: Colors.white,
                  onPressed: () {},
                ),
                FlatButton(
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    width: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white,),
                        Text('My List', style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                  color: Color(0xff4f4f4f),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget makeNetflixOrig(String title) {
    return new Container(
      padding: EdgeInsets.only(top: 30, left: 10),
      height: 400,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: topMenuStyle),
                ]
            ),
          ),
          Container(
            height: 350,
            child: ListView(
                padding: EdgeInsets.only(right: 6),
                scrollDirection: Axis.horizontal,
                //shrinkWrap: true,
                children: makeOriginals()
            ),
          )
        ],
      ),
    );
  }

  int counter = 0;
  List<Widget> makeOriginals() {
    List<Container> movieList = [];
    for (int i = 0; i < 6; i++) {
      counter++;
      movieList.add(new Container(
        margin: EdgeInsets.only(right: 10, top: 10),
        width: 200,

        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("lib/assets/" + counter.toString() + ".jpg"),
              fit: BoxFit.fitHeight
          ),
        ),
      ));
      if (counter == 12) {
        counter = 0;
      }
    }
    return movieList;
  }

  Widget makePopularWidget(String title) {
    return new Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      height: 220,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: topMenuStyle),
                ]
            ),
          ),
          Container(
            height: 200,
            child: ListView(
                padding: EdgeInsets.all(3),
                scrollDirection: Axis.horizontal,
                //shrinkWrap: true,
                children: makeContainers()
            ),
          )
        ],
      ),
    );
  }

  Widget makeContinueWatching(String title) {
    return new Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      height: 220,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: topMenuStyle),
                ]
            ),
          ),
          Container(
            height: 200,
            child: ListView(
                padding: EdgeInsets.all(3),
                scrollDirection: Axis.horizontal,
                //shrinkWrap: true,
                children: makeContinueContainers()
            ),
          )
        ],
      ),
    );
  }
  List<Widget> makeContainers() {
    List<Container> movieList = [];
    for (int i = 0; i < 6; i++) {
      counter++;
      movieList.add(new Container(
        padding: EdgeInsets.all(5),
        height: 200,

        child: Image(
          image: AssetImage("lib/assets/" + counter.toString() + ".jpg"),
        ),
      ));
      if (counter == 12) {
        counter = 0;
      }
    }
    return movieList;
  }

  List<Widget> makeContinueContainers() {
    List<Container> movieList = [];
    for (int i = 0; i < 6; i++) {
      counter++;
      movieList.add(new Container(
          padding: EdgeInsets.all(2),
          height: 200,

          child: Column(
            children: <Widget>[
              Container(
                height: 140,
                width: 100,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("lib/assets/" + counter.toString() + ".jpg"),
                      fit: BoxFit.fitHeight
                  ),
                ),
                child: Center(
                    child: FlatButton(
                      child: Icon(Icons.play_circle_outline, size: 70,),
                      onPressed: () {},
                    )
                ),
              ),
              Container(
                height: 30,
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.only(left: 10, right: 10),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right:25),
                      child: Text('S1:E' + i.toString(), style: TextStyle(color: Color(0xffc1c1c1)),),
                    ),
                    Icon(Icons.info, size: 15,color: Color(0xffc1c1c1))
                  ],
                ),
              )
            ],
          )
      ));
      if (counter == 12) {
        counter = 0;
      }
    }
    return movieList;
  }
}

