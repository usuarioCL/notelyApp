import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'configuracion/rutas.dart';
import 'proveedores/proveedores_aplicacion.dart';

void main() {
  runApp(const AplicacionNotely());
}

class AplicacionNotely extends StatelessWidget {
  const AplicacionNotely({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProveedoresAplicacion.obtenerProveedores(),
      child: MaterialApp.router(
        title: 'Notely',
        theme: _construirTema(),
        routerConfig: RutasAplicacion.obtenerConfigRutas(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  /// Construye el tema visual de la aplicación
  static ThemeData _construirTema() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
