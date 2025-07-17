const express = require('express')
const app = express()
const port = 3000
const bodyParser = require('body-parser')
app.use(bodyParser.json())
app.use(express.urlencoded({ extended: true }));
app.post('/insertar', (req, res) => {
    var Nombre = req.body.nombre;
    var Gmail = req.body.gmail;
    var Dni = req.body.dni;
    var Planta = req.body.planta;
    var FechaEntrega = req.body.fechaEntrega;
    var FechaDevolucion = req.body.fechaDevolucion;
 
    var mysql      = require('mysql');
    var connection = mysql.createConnection({
      host     : 'localhost',
      user     : 'alumno',
      password : 'alumnoipm',
      database : 'TpPaginaWeb'
    });
     
    connection.connect();
     
    connection.query(`INSERT INTO prestamos VALUES("${Nombre}", "${Gmail}", ${Dni}, "${Planta}", "${FechaEntrega}", "${FechaDevolucion}")`, function (error, results, fields) {
      if (error) throw error;
    });
 
    
     
    connection.end();
})
app.listen(port, () => {
console.log(`Example app listening on port ${port}`)
})