import 'package:electrobike_app_v1/pages/dashboard.dart';
import 'package:electrobike_app_v1/pages/listarProductos.dart';
import 'package:flutter/material.dart';
import 'package:electrobike_app_v1/pages/registrarProductos.dart';

const azul = 0xFF118dd5;
const gris = 0xFF1d1d1b;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  final List<Widget> _screensList = [Dashboard(), ListarProductos()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screensList.elementAt(_pageIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        child: BottomAppBar(
          color: Color(gris),
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _pageIndex = 0;
                    });
                  },
                  icon: Icon(
                    Icons.home_outlined,
                    color: _pageIndex == 0 ? Colors.white : Colors.grey,
                  ),
                  
                ),
                
                IconButton(
                  onPressed: () {
                    setState(() {
                      _pageIndex = 1;
                    });
                  },
                  icon: Icon(
                    Icons.directions_bike_outlined,
                    color: _pageIndex == 1 ? Colors.white : Colors.grey,
                  ),
                ),
                
              ],
              
            ),
            
          ),
          
        ),
        
      ),
      floatingActionButton:_pageIndex == 1 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarProductos()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        elevation: 2.0,
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    
    );
  }
}