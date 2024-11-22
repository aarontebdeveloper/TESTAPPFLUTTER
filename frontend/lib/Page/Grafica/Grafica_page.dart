import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/Tarea_Provider.dart';

class EstadisticasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);

    final estadisticas = tareaProvider.obtenerEstadisticas();

    return AlertDialog(
      title: Text('Estadísticas de tareas'),
      content: AspectRatio(
        aspectRatio: 1.0,
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: estadisticas['completadas']?.toDouble() ?? 0,
                    color: Colors.green, 
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: estadisticas['noCompletadas']?.toDouble() ?? 0,
                    color: Colors.blue, 
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: estadisticas['eliminadas']?.toDouble() ?? 0,
                    color: Colors.red, 
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('Finalizadas', style: TextStyle(fontSize: 10)),
                        );
                      case 1:
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('No Finalizadas', style: TextStyle(fontSize: 10)),
                        );
                      case 2:
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('Eliminadas', style: TextStyle(fontSize: 10)),
                        );
                      default:
                        return Text('');
                    }
                  },
                  reservedSize: 80, 
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
