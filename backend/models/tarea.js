const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Tarea = sequelize.define('Tarea', {
  nombre: {
    type: DataTypes.STRING,
    allowNull: false, 
  },
  descripcion: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  completada: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  fechaCreacion: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  eliminada: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  fechaLimite: {
    type: DataTypes.DATE,
    allowNull: true, 
  },
  prioridad: {
    type: DataTypes.STRING, 
    allowNull: false,
  },
  categoria: {
    type: DataTypes.STRING, 
    allowNull: true,
  },
  responsable: {
    type: DataTypes.STRING,  
    allowNull: true,
  },
  comentarios: {
    type: DataTypes.TEXT,  
    allowNull: true,
  }
});

module.exports = { Tarea };
