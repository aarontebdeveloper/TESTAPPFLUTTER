import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Page/Grafica/Grafica_page.dart';
import 'Page/Home/home_page.dart';
import 'Page/Splash/splash_page.dart';
import 'Page/Tareas/Tarea_Page.dart';
import 'Provider/Tarea_Provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TareaProvider(),
      child: MaterialApp(
        title: 'Gestión de Tareas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          '/home': (context) => HomePage(), 
          '/tareasPage': (context) => TareasPage(), 
          '/estadisticasPage': (context) => EstadisticasPage(), 
        },
      ),
    );
  }
}
