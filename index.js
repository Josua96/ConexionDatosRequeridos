console.log("Insertando información en la base de datos...");
var request = require('request');
request('http://cosevi.cloudapi.junar.com/api/v2/datastreams/REGIS-DE-FALLE-EN-SITIO/data.ajson/?auth_key=722b63380011db5403ebf1a9cdd63de186b1bc36&', 
	function (error, response, body) {
    if (!error && response.statusCode == 200) {
        var dia = '', mes = '', ano = '', tipoAccidente = '', provincia = '', canton = '', ruta = '', rolPersona = '',
        sexo = true, edad = '', franja = ''
        
        for (var i = 1; i < 6; i++) { //JSON.parse(response.body).result
            var respuesta = JSON.parse(response.body).result[i];

            dia = respuesta[1];
            mes = respuesta[2];
            ano = respuesta[3];
            tipoAccidente = respuesta[4];
            provincia = respuesta[5];
            canton = respuesta[6];
            ruta = respuesta[7];
            rolPersona = respuesta[8];
            if (respuesta[9] == "Mujer")
                sexo = false
            else
                sexo = true            
            edad = respuesta[10];
            franja = respuesta[12];

            // tengo los datos listos para insertar en la base de datos
            // llamar funcion de insertar
        }
        console.log("\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n*      Los datos de la tabla FALLECIDOS fueron insertados en la base de datos de manera exitosa.      *\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n");
    }
})