import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String docId;

  const DeleteDialog({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.red[100], shape: BoxShape.circle),
            child: const Icon(Icons.delete_forever, size: 50, color: Colors.red),
          ),
          const SizedBox(height: 20),
          const Text("¿Eliminar lectura?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          const Text("Estás a punto de borrar esta lectura", textAlign: TextAlign.center),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('lecturas').doc(docId).delete();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("CONFIRMAR BORRADO"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
