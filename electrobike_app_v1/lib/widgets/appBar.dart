import 'package:electrobike_app_v1/pages/Login.dart';
import 'package:electrobike_app_v1/pages/verPerfil.dart';
import 'package:flutter/material.dart';

const azul = 0xFF118dd5;
const gris = 0xFF1d1d1b;

enum MenuItemButton {
  verPefil,
  cerrarSesion,
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(65); // Tamaño preferido del AppBar

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
              print('* cierra sesion  *');
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
