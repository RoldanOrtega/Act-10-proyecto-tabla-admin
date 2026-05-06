import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_options.dart'; // Importa el archivo generado
import 'login_page.dart';
import 'menu_page.dart';
import 'inventario_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Usa las opciones de la plataforma actual
  );
  runApp(const LecturasApp());
}

class LecturasApp extends StatelessWidget {
  const LecturasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lecturas App',
      // Definimos el tema oscuro global
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/menu': (context) => const MenuPage(),
        '/inventario': (context) => InventarioPage(),
      },
    );
  }
}
