import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/modeloVerPerfil.dart';


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

  Future<VerPerfilModel> getUserProfile(int idUsuario) async {
    final url = 'http://192.168.0.4/apiElectrobike_app/login/getDataUser.php?idUsuario=$idUsuario';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('error')) {
        throw Exception(jsonResponse['error']);
      } else {
        return VerPerfilModel.fromJson(jsonResponse);
      }
    } else {
      throw Exception('Error al obtener el perfil del usuario');
    }
  }

   Future<bool> validarDocumentoRepetido (int idUsuario, String documentoUsuario) async {
    final response = await http.get(Uri.parse(
        "http://192.168.0.4/apiElectrobike_app/login/validarDocumento.php?idUsuario=$idUsuario&documentoUsuario=$documentoUsuario"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }

  Future<void> actualizarPerfil(Map<String, dynamic> data) async {
    try {
      final idUsuario =data['idUsuario'];
      final url = 'http://192.168.0.4/apiElectrobike_app/login/updateUser.php?idUsuario=$idUsuario';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']); // Mensaje de éxito de la API
      } else {
        print('Error al actualizar perfil');
      }
    } catch (e) {
      print('Error en la solicitud de actualizaciónnnn');
    }
  }

   Future<bool> validarContrasena (int idUsuario, String contrasenaUsuario) async {
    final response = await http.get(Uri.parse(
        "http://192.168.0.4/apiElectrobike_app/login/validarPassUser.php?idUsuario=$idUsuario&contrasenaUsuario=$contrasenaUsuario"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }

   Future<void> actualizarContrasena(Map<String, dynamic> data_) async {
    try {
      final idUsuario =data_['idUsuario'];
      final url = 'http://192.168.0.4/apiElectrobike_app/login/actualizarPass.php?idUsuario=$idUsuario';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data_),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']); // Mensaje de éxito de la API
      } else {
          print('Error al actualizar contraseña');
      }
    } catch (e) {
      print('Error en la solicitud de actualizaciónnnn: $e');
    }
  }

  
}
