import 'package:flutter/material.dart';
import '../../Provider/Tarea_Provider.dart';
import '../../modelos/tarea_model.dart';

class TareaController {
  final TareaProvider tareaProvider;

  TareaController({required this.tareaProvider});

  Future<void> agregarTarea(BuildContext context, Tarea tarea) async {
    try {
      await tareaProvider.agregarTarea(tarea);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea agregada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar tarea')),
      );
    }
  }

  Future<void> completarTarea(BuildContext context, int id) async {
    try {
      await tareaProvider.completarTarea(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea completada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al completar tarea')),
      );
    }
  }

  Future<void> eliminarTarea(BuildContext context, int id) async {
    try {
      await tareaProvider.eliminarTarea(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea eliminada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar tarea')),
      );
    }
  }

  Future<void> actualizarTarea(BuildContext context, Tarea tarea) async {
    try {
      await tareaProvider.actualizarTarea(tarea);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea actualizada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar tarea')),
      );
    }
  }
}
