import 'package:flutter/material.dart';

import '../controllers/controllerProductos.dart';

class CuadrosInformativos extends StatefulWidget {
  @override
  State<CuadrosInformativos> createState() => CuadrosInformativosState();
}

class CuadrosInformativosState extends State<CuadrosInformativos> {
  String totalCompras = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
               child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Text('Cantidad de Compras'),
              
            ),

          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Text('Cantidad de ventas'),
              
            ),

          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
