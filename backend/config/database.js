const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('postgres://postgres:auto2345@localhost:5432/test_tareas_trabajo', {
  dialect: 'postgres',
});

sequelize.authenticate()
  .then(() => {
    console.log('Conexión a la base de datos establecida con éxito.');
  })
  .catch((error) => {
    console.error('No se pudo conectar a la base de datos:', error);
  });

module.exports = sequelize;
