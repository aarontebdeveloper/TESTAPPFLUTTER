const express = require('express');
const TareaController = require('../controller/tareaController');

const router = express.Router();

router.get('/listar', TareaController.listarTareas);
router.post('/agregar', TareaController.agregarTarea);
router.put('/:id/completar', TareaController.completarTarea);
router.delete('/:id/eliminar', TareaController.eliminarTarea);
router.get('/estado', TareaController.obtenerEstadoTareas);
router.put('/:id/actualizar', TareaController.actualizarTarea);


module.exports = router;
