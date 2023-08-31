import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:electrobike_app_v1/controllers/controllerContrasena.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

class RecuperarContrasenaPage extends StatefulWidget {
  @override
  _RecuperarContrasenaPageState createState() =>
      _RecuperarContrasenaPageState();
}

class _RecuperarContrasenaPageState extends State<RecuperarContrasenaPage> {
  final TextEditingController emailController = TextEditingController();
  String mensaje = '';
  ControllerContrasena controllerContrasena = ControllerContrasena();
  final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$'); // Expresión regular para validar correo electrónico
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  bool _isLoading = false;

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Hay conexión a internet
      }
    } on SocketException catch (_) {
      return false; // No hay conexión a internet
    }
    return false; // No hay conexión a internet
  }

  Future<bool> validarCorreo(correoUsuario) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      setState(() {
        _isLoading = false;
      });
      FlutterToastr.show(
        "Verifique su conexión a internet",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFf27474),
      );

      return false;
    }
    // Iniciar el temporizador durante una duración fija
    _timer = Timer(Duration(seconds: 30), () {
      FlutterToastr.show(
        "Tiempo de espera agotado",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFf27474),
      );
      setState(() {
        _isLoading = false;
      });
    });

    bool isExist =
        await controllerContrasena.validarCorreoExisten(correoUsuario);
    _timer?.cancel();
    if (isExist == false) {
      FlutterToastr.show(
        "El correo no se encuentra registrado",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFf27474),
      );
      setState(() {
        _isLoading = false;
      });
      return false;
    } else {
      try {
        final response =
            await controllerContrasena.recuperarContrasena(correoUsuario);
        _timer?.cancel();
        FlutterToastr.show(
          "Correo enviado existosamente",
          context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.bottom,
          backgroundColor: Color(0xFF56baed),
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } catch (e) {
        _timer?.cancel();
        FlutterToastr.show(
          "Error al enviar el correo $e",
          context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.bottom,
          backgroundColor: Color(0xFFf27474),
        );
        setState(() {
          _isLoading = false;
        });
      }
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ELECTROBIKE'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Recuperar contraseña',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Text(
                    'Introduce el correo electrónico asociado a tu cuenta para cambiar tu contraseña.',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 60.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingrese el correo';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el correo electronico',
                      labelText: 'Correo Electonico',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.blueAccent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(height: 80.0),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(200.0, 50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String userEmail = emailController.text.trim();
                              if (!emailRegex.hasMatch(userEmail)) {
                                FlutterToastr.show(
                                  "Por favor ingrese un correo valido",
                                  context,
                                  duration: FlutterToastr.lengthLong,
                                  position: FlutterToastr.bottom,
                                  backgroundColor: Color(0xFFf27474),
                                );
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                validarCorreo(userEmail);
                              }
                            }
                          },
                          child: Text('Recuperar'),
                        ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          )),
    );
  }
}
