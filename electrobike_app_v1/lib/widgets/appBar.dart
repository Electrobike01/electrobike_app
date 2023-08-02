import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import '../controllers/controllerUsuario.dart';
import '../pages/Login.dart';
import '../pages/verPerfil.dart';


const azul = 0xFF118dd5;
const gris = 0xFF1d1d1b;

enum MenuItemButton {
  verPefil,
  cerrarSesion,
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(65); // Tamaño preferido del AppBar

  final UserController _userController = UserController();

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text('Cerrar Sesión'),
              onPressed: () async {
                await _userController.destroySession();
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(azul),
      automaticallyImplyLeading: false, // Esto evita que se muestre la flecha de retroceso
      title: Text('ELECTROBIKE'),
      toolbarHeight: 100, // Cambiar esta línea al valor deseado (en píxeles)
      elevation: 0,
      actions: <Widget>[
        PopupMenuButton<MenuItemButton>(
          onSelected: (value) {
            if (value == MenuItemButton.verPefil) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const VerPerfil()),
              );
            } else if (value == MenuItemButton.cerrarSesion) {
              _showLogoutConfirmationDialog(context); // Llama al método para mostrar la alerta
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: MenuItemButton.verPefil,
              child: Text('Ver perfil'),
            ),
            PopupMenuItem(
              value: MenuItemButton.cerrarSesion,
              child: Text('Cerrar sesion'),
            ),
          ],
          child: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              child: Icon(
                Icons.person,
                size: 30,
                color: Color(azul),
              ),
              backgroundColor: Colors.white
            ),
          ),
        )
      ],
    );
  }
}
