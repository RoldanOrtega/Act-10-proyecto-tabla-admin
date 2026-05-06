import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDialog extends StatelessWidget {
  AddDialog({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A), // Negro casi puro
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.add_circle, color: Color(0xFFFF69B4)),
          SizedBox(width: 10),
          Text("Registrar Lectura", style: TextStyle(color: Colors.white)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildField(nameController, "Nombre del Libro", Icons.book),
            _buildField(categoryController, "Categoría", Icons.category),
            _buildField(pagesController, "Páginas", Icons.format_list_numbered),
            _buildField(authorController, "Autor / Material", Icons.person),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(color: Colors.redAccent)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
          onPressed: () async {
            final payload = {
              'nombre': nameController.text,
              'categoria': categoryController.text,
              'paginas': int.parse(pagesController.text),
              'autor': authorController.text,
            };
            await FirebaseFirestore.instance.collection('lecturas').add(payload);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text("Guardar Lectura"),
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white), // Cambiado a blanco para que contraste
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800], // Un gris oscuro que funciona mejor
          prefixIcon: Icon(icon, color: Colors.white70),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFF69B4)),
          ),
        ),
      ),
    );
  }
}
