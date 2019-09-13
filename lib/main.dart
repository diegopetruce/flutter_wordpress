import 'package:flutter/material.dart';
import 'homepage.dart';
import 'noticias02.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

void main() => runApp(Netflix());

class Netflix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clube do Consignado',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 100,
              height: 100,
              child: FlareActor(
                'lib/assets/ClubeC.flr',
                animation: 'Spin',
              ),
            ),
          ),
        ],
      )

    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 6)).then((_){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NetflixTabBar())
      );
    });
  }
}

class NetflixTabBar extends StatefulWidget {
  @override
  _NetflixTabBarState createState() => _NetflixTabBarState();
}

class _NetflixTabBarState extends State<NetflixTabBar> {

  int _selectedIndex=0;
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Scaffold(
            bottomNavigationBar: BottomNavyBar(
              backgroundColor: Colors.deepPurple,
              selectedIndex: _selectedIndex,
              showElevation: true, // use this to remove appBar's elevation
              onItemSelected: (index) => setState(() {
                _selectedIndex = index;
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 600), curve: Curves.ease);
              }),
              items: [
                BottomNavyBarItem(
                  icon: Icon(Icons.view_carousel),
                  title: Text('Notícias'),
                  activeColor: Colors.white70,
                ),
                BottomNavyBarItem(
                    icon: Icon(Icons.video_library),
                    title: Text('Vídeos'),
                    activeColor: Colors.white70
                ),
                BottomNavyBarItem(
                    icon: Icon(Icons.message),
                    title: Text('Messages'),
                    activeColor: Colors.white70
                ),
                /*BottomNavyBarItem(
                    icon: Icon(Icons.settings),
                    title: Text('Settings'),
                    activeColor: Colors.white70
                ),*/
              ],
            ),
            body: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
              children: <Widget>[
                VirtuoozaHome(),
                HomePage(),
              ],
            )
            /*TabBarView(
              children: [
                VirtuoozaHome(),
                HomePage(),
                // Center( child: Text("Page 3"),),
                //Center( child: Text("Page 4")),
              ],*/
            ),
          ),
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

}






