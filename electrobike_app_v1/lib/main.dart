import 'package:electrobike_app_v1/pages/Login.dart';
import 'package:electrobike_app_v1/pages/home.dart';
import 'package:electrobike_app_v1/pages/listarProductos.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    routes:{
      '/':((context)=>Login()),
      // '/listarProductos': (context) => ListarProductos(),
    },

  ),
);
