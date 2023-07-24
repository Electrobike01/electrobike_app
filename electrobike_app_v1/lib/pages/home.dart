import 'package:electrobike_app_v1/pages/dashboard.dart';
import 'package:electrobike_app_v1/pages/listarProductos.dart';
import 'package:flutter/material.dart';

const azul = 0xFF118dd5;
const gris = 0xFF1d1d1b;


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  final List<Widget> _screensList = [dashboard(), ListarProductos()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screensList.elementAt(_pageIndex),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment(0.0, 1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  backgroundColor: Color(gris),
                  currentIndex: _pageIndex,
                  onTap: (int index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.directions_bike_outlined),
                      label: 'Productos',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
