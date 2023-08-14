import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import '../controllers/controllerUsuario.dart';
import 'home.dart';
import 'dart:io';

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
                        SizedBox(height: 60),
                        Center(
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(azul),
                                    minimumSize: Size(120, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: Text('Iniciar Sesión'),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      






                                      setState(() {
                                        _isLoading = true;
                                      });
                                      String email = emailUsuario.text.trim();
                                      String password = passUsuario.text.trim();
                                      bool success =
                                          await _userController.Login(
                                              email, password);
                                      if (success) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()),
                                        );
                                      } else {
                                        FlutterToastr.show(
                                          "Error al iniciar",
                                          context,
                                          duration: FlutterToastr.lengthLong,
                                          position: FlutterToastr.bottom,
                                          backgroundColor: Colors.red,
                                        );
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                ),
                        ),
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
