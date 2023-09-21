// ======================== IMPORTACIONES ========================
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserProfileModel.dart';
import '../models/modeloActualizarContrasena.dart';
import '../models/modeloVerPerfil.dart';

// Se crea la clase que contiene los metodos
class UserController {
  // Hay que hacer esto en los controllers
  final String apiUrl =
      'https://electrobike-adso-wild.000webhostapp.com/controllers/';


      

  Future<Map<String, dynamic>> Login(String email, String password) async {
    final response = await http.post(
      Uri.parse(
          'https://electrobike-adso-wild.000webhostapp.com/controllers/login/Movil/loginMovil.php'
          // 'http://192.168.0.4/apiElectrobike_app/login/login.php'
          ),
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
      // print('data:$data');
      return data; // Devuelve la respuesta completa del servidor
    } else {
      throw Exception('Error en la solicitud HTTP');
    }
  }

  // Metodo para obtener el idUsuario desde el localStorage
  Future<int?> getUserIdFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUsuario = prefs.getInt('idUsuario');
    return idUsuario;
  }

  // Método para destruir la sesión
  Future<void> destroySession() async {
    await http.get(Uri.parse(
        'https://electrobike-adso-wild.000webhostapp.com/controllers/login/Movil/destroy_sessionMovil.php'
        // 'http://192.168.0.4/apiElectrobike_app/login/destroy_session.php'
        ));
    // Eliminar idUsuario del localStorage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('idUsuario');
  }

  // Metodo para obtener los datos del usuario para actualizar
  Future<VerPerfilModel> getUserProfile(int idUsuario) async {
    final url =
        'https://electrobike-adso-wild.000webhostapp.com/controllers/login/Movil/getDataUserMovil.php?idUsuario=$idUsuario';
        // 'http://192.168.0.4/apiElectrobike_app/login/getDataUser.php?idUsuario=$idUsuario';
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

  // Validar que el documento no exista al momento de actualizar
  Future<bool> validarDocumentoRepetido(
      int idUsuario, String documentoUsuario) async {
    final response = await http.get(Uri.parse(
        "https://electrobike-adso-wild.000webhostapp.com/controllers/login/Movil/validarDocumentoMovil.php?idUsuario=$idUsuario&documentoUsuario=$documentoUsuario"
        // "http://192.168.0.4/apiElectrobike_app/login/validarDocumento.php?idUsuario=$idUsuario&documentoUsuario=$documentoUsuario"
        ));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }

  Future<String> actualizarPerfil(UserProfileModel userProfile) async {
    try {
      final actualizar_usuario = 
       
      'https://electrobike-adso-wild.000webhostapp.com/controllers/login/Movil/actualizarUserMovil.php';
      // 'http://192.168.0.4/apiElectrobike_app/login/actualizarUser.php';
      final response = await http.post(Uri.parse(actualizar_usuario),
          body: userProfile.toJsonUpdate());

      print(userProfile.toJsonUpdate());
      if (response.statusCode == 200) {
        return response.body;
        // print(responseData['message']); // Mensaje de éxito de la API
      } else {
        return 'Error';
      }
    } catch (e) {
      print('Error en la solicitud de actualización: $e');
      return 'Error';
    }
  }

  // Valida que la contraseña si corresponda al usuario que la va a modificar
  Future<bool> validarContrasena(
      int idUsuario, String contrasenaUsuario) async {
    final response = await http.get(Uri.parse(
        "https://electrobike-adso-wild.000webhostapp.com/controllers/login/Movil/validarPassUserMovil.php?idUsuario=$idUsuario&contrasenaUsuario=$contrasenaUsuario"

        // "http://192.168.0.4/apiElectrobike_app/login/validarPassUser.php?idUsuario=$idUsuario&contrasenaUsuario=$contrasenaUsuario"
        ));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }



  Future<String> actualizarContrasena(ModeloContrasena modeloContrasena) async {
    try {
      final actualizar_pass =
          'https://electrobike-adso-wild.000webhostapp.com/controllers/login/Movil/actualizarPassMovil.php';
          // 'http://192.168.0.4/apiElectrobike_app/login/actualizarPass.php';
      final response = await http.post(Uri.parse(actualizar_pass),
          body: modeloContrasena.toJsonUpdate());

      if (response.statusCode == 200) {
        return response.body;
        
      } else {
        return 'Error';
      }
    } catch (e) {
      print('Error en la solicitud de actualización: $e');
    return 'Error';
    }
  }

}
