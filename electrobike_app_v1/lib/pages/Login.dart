import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import '../controllers/controllerUsuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

const azul = 0xFF118dd5;

class _LoginState extends State<Login> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailUsuario = TextEditingController();
  TextEditingController passUsuario = TextEditingController();
  final UserController _userController = UserController();
  Timer? _timer;

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

  Future<bool> iniciarSesion(Map<String, dynamic> dataLogin) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      FlutterToastr.show(
        "Verifique su conexión a internet",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFd53b3b),
      );
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    // Iniciar el temporizador durante una duración fija
    _timer = Timer(Duration(seconds: 30), () {
      FlutterToastr.show(
        "Tiempo de espera agotado",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFd53b3b),
      );
      setState(() {
        _isLoading = false;
      });
    });

    // Inicio de inicio de sesión
    String email = dataLogin['emailUsuario'];
    String password = dataLogin['contrasenaUsuario'];
    // bool success = await _userController.Login(email, password);
    Map<String, dynamic> response =
        await _userController.Login(email, password);
    print('Respuesta: $response');
    bool success = response['success'];
    // Cancelar el temporizador despues de inicar sesion
    _timer?.cancel();

    if (success == true) {
      // print('se puede');
      int idUsuario = response['idUsuario'];
      // Guardar el idUsuario en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('idUsuario', idUsuario);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      return true;
    } else if (success == false) {
      // Map<String, dynamic> jsonResponse = json.decode(success.m);
      // message = jsonResponse['message'];
      String message = response['message'];

      FlutterToastr.show(
        "No se pudo iniciar sesión \n $message",
        context,
        duration: 3,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFd53b3b),
      );
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(azul),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Color(azul),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(60, 60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.person, size: 50),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Text(
                    'Bienvenido',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Inicie sesión para continuar.',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        TextFormField(
                          controller: emailUsuario,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Este campo es obligatorio";
                            }
                            bool emailValid =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value.trim());
                            if (!emailValid) {
                              return 'Por favor ingrese un correo electrónico válido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Ingrese su correo electronico',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passUsuario,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Este campo es obligatorio";
                            }
                            return null;
                          },
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: 'Contraseña',
                            labelText: 'Ingrese la contraseña',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(height: 80),
                        Center(
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(200.0, 50),
                                    backgroundColor: Color(azul),
                                  ),
                                  child: Text('Iniciar Sesión'),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      Map<String, dynamic> dataLogin = {
                                        'emailUsuario':
                                            emailUsuario.text.trim(),
                                        'contrasenaUsuario': passUsuario.text,
                                      };
                                      iniciarSesion(dataLogin);
                                    }
                                  },
                                ),
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
