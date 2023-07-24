import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:flutter/material.dart';


class ListarProductos extends StatefulWidget {
  const ListarProductos({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ListarProductos> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          Text('Aqui va el listar Productos'),
        ],
      ),
  
    );
  }
}
