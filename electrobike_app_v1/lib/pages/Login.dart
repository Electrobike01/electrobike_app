
import 'package:electrobike_app_v1/widgets/formularioInicioSesion.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

const azul = 0xFF118dd5;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // para que se ajuste automaticamente cuando salga el teclado
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Color(azul),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: FormularioInicioSesion(),
        ));
  }
}
