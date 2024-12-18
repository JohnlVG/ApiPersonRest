import 'package:flutter/material.dart';
import '../server/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> personas = [];

  @override
  void initState() {
    super.initState();
    cargarPersonas();
  }

  Future<void> cargarPersonas() async {
    try {
      final data = await apiService.obtenerPersonas();
      setState(() {
        personas = data;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void mostrarFormulario({Map<String, dynamic>? persona}) {
    final _formKey = GlobalKey<FormState>();
    final _nombreController = TextEditingController();
    final _apellidoController = TextEditingController();
    final _telefonoController = TextEditingController();

    if (persona != null) {
      _nombreController.text = persona['nombre'];
      _apellidoController.text = persona['apellido'];
      _telefonoController.text = persona['telefono'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(persona == null ? "Agregar Persona" : "Editar Persona"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: "Nombre"),
                  validator: (value) => value!.isEmpty ? "Por favor ingrese un nombre" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _apellidoController,
                  decoration: InputDecoration(labelText: "Apellido"),
                  validator: (value) => value!.isEmpty ? "Por favor ingrese un apellido" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _telefonoController,
                  decoration: InputDecoration(labelText: "Teléfono"),
                  validator: (value) => value!.isEmpty ? "Por favor ingrese un teléfono" : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(persona == null ? "Agregar" : "Guardar"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final nuevaPersona = {
                    "nombre": _nombreController.text,
                    "apellido": _apellidoController.text,
                    "telefono": _telefonoController.text,
                  };

                  if (persona == null) {
                    await apiService.crearPersona(nuevaPersona);
                  } else {
                    await apiService.actualizarPersona(persona['_id'], nuevaPersona);
                  }

                  cargarPersonas();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Listar Personas",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto', // Cambiar fuente si se desea
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1.png'),
            fit: BoxFit.cover,
            opacity: 0.5, // Para que la imagen no opaque los elementos
          ),
        ),
        child: Center(
          child: Container(
            width: double.infinity, // Ancho completo
            height: 400, // Altura fija, ajusta según prefieras
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7), // Fondo blanco semi-transparente
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              itemCount: personas.length,
              itemBuilder: (context, index) {
                final persona = personas[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    title: Text(
                      "${persona['nombre']} ${persona['apellido']}",
                      style: TextStyle(fontSize: 20), // Aumento de tamaño de letra
                    ),
                    subtitle: Text(
                      "Teléfono: ${persona['telefono']}",
                      style: TextStyle(fontSize: 16), // Aumento de tamaño de letra
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => mostrarFormulario(persona: persona),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await apiService.eliminarPersona(persona['_id']);
                            cargarPersonas();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () => mostrarFormulario(),
      ),
    );
  }
}
