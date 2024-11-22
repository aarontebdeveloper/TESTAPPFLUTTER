const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const sequelize = require('./config/database');
const RoutesTareas = require('./Routes/RoutesTareas');
const { Tarea } = require('./models/tarea');

const app = express();
app.use(express.json());

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
}));


app.use('/api/tareas', RoutesTareas);

const server = http.createServer(app);
const io = new Server(server);

io.on('connection', async (socket) => {
  console.log('Cliente conectado');
  const tareasCompletadas = await Tarea.count({ where: { completada: true } });
  const totalTareas = await Tarea.count();
  const tareasPendientes = totalTareas - tareasCompletadas;
  const estadoTareas = { totalTareas, tareasCompletadas, tareasPendientes };
  socket.emit('estadoTareas', estadoTareas);
});


sequelize.sync()
  .then(() => {
    const port = 3000;
    const host = '0.0.0.0';
    server.listen(port, host, () => {
      console.log(`Servidor corriendo en http://${host}:${port}`);
    });
  })
  .catch((err) => {
    console.error('Error al sincronizar la base de datos:', err);
  });
