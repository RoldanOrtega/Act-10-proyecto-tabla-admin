import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/add_dialog.dart';
import 'package:myapp/widgets/delete_dialog.dart';
import 'package:myapp/widgets/update_dialog.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final CollectionReference lecturas = FirebaseFirestore.instance.collection('lecturas');

  void _mostrarFormulario(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDialog();
      },
    );
  }

  void _mostrarFormularioUpdate(BuildContext context, String docId, String nombre, String categoria, int paginas, String autor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateDialog(docId: docId, nombre: nombre, categoria: categoria, paginas: paginas, autor: autor,);
      },
    );
  }

  void _confirmarBorrado(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Added a key for safety, though not strictly necessary here since it's a new dialog each time.
        return DeleteDialog(key: ValueKey(docId), docId: docId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Inventario de Lecturas", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: lecturas.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Displaying the actual error is better than a generic message
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Handle the case where there is no data.
            return Column(
              children: [
                _buildSummaryCards(0), // Show 0 total
                const Expanded(
                  child: Center(
                    child: Text(
                      'No hay lecturas en el inventario.\n¡Agrega una para empezar!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            );
          }

          final docs = snapshot.data!.docs;

          return Column(
            children: [
              _buildSummaryCards(docs.length),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2E44), // Color oscuro de la tabla
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView(
                    children: [
                      _buildHeaderTable(),
                      ...docs.map((doc) => _buildDataRow(doc, context)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFF69B4), // Rosa Fuerte
        onPressed: () => _mostrarFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text("Agregar Lectura"),
      ),
    );
  }

  // Updated to accept the total count
  Widget _buildSummaryCards(int total) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
             color: const Color(0xFF1F2E44), // Match table color
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                "Total de Lecturas: $total",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTable() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use SpaceBetween for better alignment
        children: [
          Expanded(flex: 3, child: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Categoría", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("Páginas", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Acciones", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  // Updated to be safer
  Widget _buildDataRow(DocumentSnapshot doc, BuildContext context) {
    final data = doc.data() as Map<String, dynamic>?;

    final nombre = data?['nombre']?.toString() ?? 'N/A';
    final categoria = data?['categoria']?.toString() ?? 'N/A';
    final paginas = data?['paginas'] ?? 0;
    final autor = data?['autor']?.toString() ?? 'N/A';


    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 3, child: Text(nombre)),
          Expanded(flex: 2, child: Text(categoria)),
          Expanded(flex: 1, child: Text("$paginas pág", textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.orange, size: 20), onPressed: () {
                   _mostrarFormularioUpdate(context, doc.id, nombre, categoria, paginas, autor);
                }),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _confirmarBorrado(context, doc.id),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
