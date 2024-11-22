const { Tarea } = require('../models/tarea');

const listarTareas = async (req, res) => {
  try {
    const tareas = await Tarea.findAll();  
    const tareasFiltradas = tareas.map(tarea => {
      if (tarea.eliminada) {
        delete tarea.completada;
      }
      return tarea;
    });
    res.json(tareasFiltradas); 
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener las tareas' });  
  }
};



const agregarTarea = async (req, res) => {
  const { nombre, descripcion, fechaLimite, prioridad, categoria, responsable, comentarios } = req.body;
  try {
    await Tarea.create({
      nombre,
      descripcion,
      fechaLimite,
      prioridad,
      categoria,
      responsable,
      comentarios
    });
    res.status(201).json({
      message: 'Tarea creada con éxito'
    });
  } catch (err) {
    console.error(err);  
    res.status(500).json({ error: 'Error al crear la tarea', details: err.message });
  }
};

const completarTarea = async (req, res) => {
  const { id } = req.params;
  try {
    const tarea = await Tarea.findByPk(id);
    if (!tarea) return res.status(404).json({ error: 'Tarea no encontrada' });
    tarea.completada = true;
    await tarea.save();
    res.json(tarea);
  } catch (err) {
    res.status(500).json({ error: 'Error al completar la tarea' });
  }
};


const actualizarTarea = async (req, res) => {
  const { id } = req.params;
  const { nombre, descripcion, fechaLimite, prioridad, categoria, responsable, comentarios, completada, eliminada } = req.body;

  try {
    const tarea = await Tarea.findByPk(id);

    if (!tarea) return res.status(404).json({ error: 'Tarea no encontrada' });

    tarea.nombre = nombre || tarea.nombre;
    tarea.descripcion = descripcion || tarea.descripcion;
    tarea.fechaLimite = fechaLimite || tarea.fechaLimite;
    tarea.prioridad = prioridad || tarea.prioridad;
    tarea.categoria = categoria || tarea.categoria;
    tarea.responsable = responsable || tarea.responsable;
    tarea.comentarios = comentarios || tarea.comentarios;
    tarea.completada = completada !== undefined ? completada : tarea.completada;
    tarea.eliminada = eliminada !== undefined ? eliminada : tarea.eliminada;

    await tarea.save();

    res.json(tarea);
  } catch (err) {
    res.status(500).json({ error: 'Error al actualizar la tarea' });
  }
};

const eliminarTarea = async (req, res) => {
  const { id } = req.params;
  try {
    const tarea = await Tarea.findByPk(id);
    if (!tarea) return res.status(404).json({ error: 'Tarea no encontrada' });

    tarea.eliminada = true;  
    await tarea.save();
    res.json({ message: 'Tarea eliminada' });
  } catch (err) {
    res.status(500).json({ error: 'Error al eliminar la tarea' });
  }
};

const obtenerEstadoTareas = async (req, res) => {
  try {
    const totalTareas = await Tarea.count({ where: { eliminada: false } });
    const tareasCompletadas = await Tarea.count({
      where: { completada: true, eliminada: false },
    });
    const tareasPendientes = totalTareas - tareasCompletadas;
    const tareasEliminadas = await Tarea.count({
      where: { eliminada: true },
    });

    res.json({
      totalTareas,
      tareasCompletadas,
      tareasPendientes,
      tareasEliminadas, 
    });
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener el estado de las tareas' });
  }
};



module.exports = {
  listarTareas,
  agregarTarea,
  completarTarea,
  eliminarTarea,
  obtenerEstadoTareas,
  actualizarTarea,
};
