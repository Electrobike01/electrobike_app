import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<Map<String, dynamic>> getUserData(int? idUsuario) async {
    try {
      // Verifica si el idUsuario es null o 0, si es así, no realiza la solicitud a la API
      if (idUsuario == null || idUsuario == 0) {
        return {}; // Devuelve un mapa vacío para indicar que no se encontraron datos
      }

      // Realiza la solicitud a la API para obtener los detalles del usuario por su id
      final response = await http.get(Uri.parse('$apiUrl/login/getDataUser.php?id=$idUsuario'));

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, decodifica el JSON de la respuesta
        final data = jsonDecode(response.body);

        // Devuelve los datos del usuario como un mapa
        return data;
      } else {
        throw Exception('Error en la solicitud HTTP');
      }
    } catch (e) {
      print('Error al obtener los detalles del usuario: $e');
      throw Exception('Error en la solicitud HTTP');
    }
  }

  Future<void> actualizarUsuario(int idUsuario, String nuevoNombre, String nuevoCorreo) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login/updateUserData.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idUsuario': idUsuario,
          'nombre': nuevoNombre,
          'correo': nuevoCorreo,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          // El servidor ha actualizado exitosamente los datos del usuario
        } else {
          throw Exception('Error al actualizar el perfil');
        }
      } else {
        throw Exception('Error en la solicitud HTTP');
      }
    } catch (e) {
      print('Error al actualizar el perfil: $e');
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
