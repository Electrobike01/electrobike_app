import 'package:electrobike_app_v1/pages/listarProductos.dart';
import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:electrobike_app_v1/widgets/barraNav.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final Screens = [
    Home(),
    ListarProductos()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          children: [
            Text('Dasboard'),
          ],
        ),
      ),
        bottomNavigationBar: GNav(
          selectedIndex: _currentIndex,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
              // iconActiveColor: Colors.white,
              // textColor: Colors.grey,
            ),
          
            GButton(
              icon: Icons.home,
              text: 'Productos',
              // iconActiveColor: Colors.white,
              // textColor: Colors.grey,
            ),
          ],
        )
    );
    
  }
}
