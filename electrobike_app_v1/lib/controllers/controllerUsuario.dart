import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/modeloUsuario.dart';

class UserController {
  final String apiUrl = 'http://192.168.0.4/apiElectrobike_app/';

  Future<bool> Login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login/login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'correoUsuario': email,
        'contrasenaUsuario': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success']) {
        int idUsuario = data['idUsuario'];

        // Guardar el idUsuario en el localStorage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('idUsuario', idUsuario);

        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Error en la solicitud HTTP');
    }
  }
  
  // Método para obtener el idUsuario desde el localStorage
  Future<int?> getUserIdFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUsuario = prefs.getInt('idUsuario');
    return idUsuario;
  }

  // Método para destruir la sesión
  Future<void> destroySession() async {
    await http.get(Uri.parse('$apiUrl/login/destroy_session.php'));
    // Eliminar idUsuario del localStorage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('idUsuario');
  }
}
