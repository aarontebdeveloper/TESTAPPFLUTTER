import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modelos/tarea_model.dart';

class TareaProvider extends ChangeNotifier {
  List<Tarea> _tareas = [];
  final String baseUrl ='http://192.168.3.94:3000/api/tareas'; 

  List<Tarea> get tareas => _tareas;

  Future<void> obtenerTareas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/listar'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _tareas = data.map((tarea) => Tarea.fromJson(tarea)).toList();
        notifyListeners();
      } else {
        throw Exception('Error al cargar tareas');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
Future<void> actualizarTarea(Tarea tarea) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/${tarea.id}/actualizar'),  
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarea.toJson()), 
    );
    
    if (response.statusCode == 200) {
      int index = _tareas.indexWhere((t) => t.id == tarea.id);
      if (index != -1) {
        _tareas[index] = tarea;
        notifyListeners();
      }
    } else {
      throw Exception('Error al actualizar la tarea');
    }
  } catch (e) {
    print('Error: $e');
  }
}
  Future<void> agregarTarea(Tarea tarea) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/agregar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tarea.toJson()),
      );
      if (response.statusCode == 201) {
        _tareas.add(Tarea.fromJson(json.decode(response.body)));
        notifyListeners();
      } else {
        throw Exception('Error al agregar tarea');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> completarTarea(int id) async {
    try {
      final tarea = _tareas.firstWhere((t) => t.id == id);
      tarea.completada = true;
      final response = await http.put(
        Uri.parse('$baseUrl/$id/completar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tarea.toJson()),
      );
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Error al completar tarea');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> eliminarTarea(int id) async {
    try {
      final tarea = _tareas.firstWhere((t) => t.id == id);
      tarea.eliminada = true; 
      final response = await http.delete(Uri.parse('$baseUrl/$id/eliminar'));
      if (response.statusCode == 200) {
        _tareas.removeWhere(
            (t) => t.id == id); 
        notifyListeners();
      } else {
        throw Exception('Error al eliminar tarea');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
Map<String, int> obtenerEstadisticas() {
  List<Tarea> tareasActivas = _tareas.where((tarea) => !tarea.eliminada).toList();
  int completadas = tareasActivas.where((tarea) => tarea.completada).length;
  int noCompletadas = tareasActivas.where((tarea) => !tarea.completada).length;
  int eliminadas = _tareas.where((tarea) => tarea.eliminada).length; 

  print(
      'Completadas: $completadas, No completadas: $noCompletadas, Eliminadas: $eliminadas');
  return {
    'completadas': completadas,
    'noCompletadas': noCompletadas,
    'eliminadas': eliminadas,
  };
}
}
