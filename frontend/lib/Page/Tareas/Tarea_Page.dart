import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/Tarea_Provider.dart';
import '../../modelos/tarea_model.dart';
import '../Grafica/Grafica_page.dart';
import 'Tarea_Page.controller.dart';

class TareasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);
    final tareaController = TareaController(tareaProvider: tareaProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tareaProvider.obtenerTareas();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tareas Programadas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 109, 231),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.bar_chart),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => EstadisticasPage(),
                  );
                },
                color: const Color.fromARGB(255, 249, 250, 249),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _mostrarFormularioCrearTarea(context, tareaController);
                },
                color: const Color.fromARGB(255, 249, 250, 249),
              ),
            ],
          ),
        ],
      ),
      body: tareaProvider.tareas
              .where((tarea) => !tarea.eliminada)
              .toList()
              .isEmpty
          ? Center(
              child: Text(
                'No hay tareas registradas. Por favor, crea una tarea',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tareaProvider.tareas
                        .where((tarea) => !tarea.eliminada)
                        .toList()
                        .length,
                    itemBuilder: (context, index) {
                      final tarea = tareaProvider.tareas
                          .where((tarea) => !tarea.eliminada)
                          .toList()[index];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          title: Text('Nombre de la Tarea: ${tarea.nombre}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Descripción: ${tarea.descripcion}'),
                              Text(
                                  'Creación: ${tarea.fechaCreacion.toLocal()}'),
                              if (tarea.fechaLimite != null)
                                Text(
                                    'Fecha límite: ${tarea.fechaLimite?.toLocal()}'),
                              Text('Prioridad: ${tarea.prioridad}'),
                              if (tarea.categoria != null)
                                Text('Categoría: ${tarea.categoria}'),
                              if (tarea.responsable != null)
                                Text('Responsable: ${tarea.responsable}'),
                              if (tarea.comentarios != null)
                                Text('Comentarios: ${tarea.comentarios}'),
                              if (tarea.completada)
                                Text(
                                  'Terminada',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (tarea.completada)
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 28)
                              else
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () => tareaController
                                      .completarTarea(context, tarea.id),
                                  child: Text('Completar tarea'),
                                ),
                              SizedBox(width: 5),
                              if (!tarea.completada) ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () => tareaController
                                      .eliminarTarea(context, tarea.id),
                                  child: Text('Eliminar tarea'),
                                ),
                                SizedBox(width: 5),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () =>
                                      _mostrarFormularioActualizarTarea(
                                          context, tareaController, tarea),
                                  child: Text('Actualizar tarea'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _mostrarFormularioCrearTarea(
      BuildContext context, TareaController tareaController) {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final prioridadController = TextEditingController();
    final fechaLimiteController = TextEditingController();
    final categoriaController = TextEditingController();
    final responsableController = TextEditingController();
    final comentariosController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Crear nueva tarea',
              style: TextStyle(
                color: const Color.fromARGB(255, 4, 131, 242),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la tarea',
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                  maxLines: 3,
                ),
                TextField(
                  controller: prioridadController,
                  decoration: InputDecoration(
                    labelText: 'Prioridad',
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                TextField(
                  controller: fechaLimiteController,
                  decoration: InputDecoration(
                    labelText: 'Fecha límite',
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      fechaLimiteController.text =
                          pickedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                TextField(
                  controller: categoriaController,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                TextField(
                  controller: responsableController,
                  decoration: InputDecoration(
                    labelText: 'Responsable',
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                TextField(
                  controller: comentariosController,
                  decoration: InputDecoration(
                    labelText: 'Comentarios',
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            TextButton(
              onPressed: () {
                if (nombreController.text.isEmpty ||
                    descripcionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Por favor, complete todos los campos.')));
                } else {
                  final nuevaTarea = Tarea(
                    id: DateTime.now().millisecondsSinceEpoch,
                    nombre: nombreController.text,
                    descripcion: descripcionController.text,
                    fechaCreacion: DateTime.now(),
                    categoria: categoriaController.text,
                    prioridad: prioridadController.text,
                    fechaLimite: fechaLimiteController.text.isNotEmpty
                        ? DateTime.parse(fechaLimiteController.text)
                        : null,
                    responsable: responsableController.text.isNotEmpty
                        ? responsableController.text
                        : null,
                    comentarios: comentariosController.text.isNotEmpty
                        ? comentariosController.text
                        : null,
                  );
                  tareaController.agregarTarea(context, nuevaTarea);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Crear Tarea',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 248, 122),
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarFormularioActualizarTarea(
      BuildContext context, TareaController tareaController, Tarea tarea) {
    final nombreController = TextEditingController(text: tarea.nombre);
    final descripcionController =
        TextEditingController(text: tarea.descripcion);
    final prioridadController = TextEditingController(text: tarea.prioridad);
    final fechaLimiteController = TextEditingController(
        text: tarea.fechaLimite?.toLocal().toString().split(' ')[0] ?? '');
    final categoriaController =
        TextEditingController(text: tarea.categoria ?? '');
    final responsableController =
        TextEditingController(text: tarea.responsable ?? '');
    final comentariosController =
        TextEditingController(text: tarea.comentarios ?? '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Actualizar tarea'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre de la tarea'),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                TextField(
                  controller: prioridadController,
                  decoration: InputDecoration(labelText: 'Prioridad'),
                ),
                TextField(
                  controller: fechaLimiteController,
                  decoration: InputDecoration(labelText: 'Fecha límite'),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: tarea.fechaLimite ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      fechaLimiteController.text =
                          pickedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                TextField(
                  controller: categoriaController,
                  decoration: InputDecoration(labelText: 'Categoría'),
                ),
                TextField(
                  controller: responsableController,
                  decoration: InputDecoration(labelText: 'Responsable'),
                ),
                TextField(
                  controller: comentariosController,
                  decoration: InputDecoration(labelText: 'Comentarios'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nombreController.text.isEmpty ||
                    descripcionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Por favor, complete todos los campos.')));
                } else {
                  final tareaActualizada = Tarea(
                    id: tarea.id,
                    nombre: nombreController.text,
                    descripcion: descripcionController.text,
                    fechaCreacion: tarea.fechaCreacion,
                    categoria: categoriaController.text,
                    prioridad: prioridadController.text,
                    fechaLimite: fechaLimiteController.text.isNotEmpty
                        ? DateTime.parse(fechaLimiteController.text)
                        : null,
                    responsable: responsableController.text.isNotEmpty
                        ? responsableController.text
                        : null,
                    comentarios: comentariosController.text.isNotEmpty
                        ? comentariosController.text
                        : null,
                  );
                  tareaController.actualizarTarea(context, tareaActualizada);
                  Navigator.pop(context);
                }
              },
              child: Text('Actualizar tarea'),
            ),
          ],
        );
      },
    );
  }
}
