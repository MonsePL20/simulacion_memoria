import 'package:flutter/material.dart';

enum Opciones { primerAjuste, mejorAjuste }

class BotonesAccion extends StatefulWidget {
  final Function(String, String, String, String) onAgregar; // ← AGREGADO 'duracion'
  final Function(String, String) onEliminar;
  final Function(Opciones) onCambioOpcion;
  final VoidCallback onReinicio;

  const BotonesAccion({
    super.key,
    required this.onAgregar,
    required this.onEliminar,
    required this.onCambioOpcion,
    required this.onReinicio,
  });

  @override
  State<BotonesAccion> createState() => _BotonesAccionState();

  //  DIALOGO AGREGAR - CON DURACION ENTRE TAMAÑO Y LLEGADA
  static void mostrarDialogoAgregar(
    BuildContext context,
    Function(String, String, String, String) onAgregar, // ← AGREGADO 'duracion'
  ) {
    final nombreCtrl = TextEditingController();
    final tamanoCtrl = TextEditingController();
    final duracionCtrl = TextEditingController(); // ← NUEVO CAMPO
    final llegadaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 420, // ← ANCHO AUMENTADO para 4 campos
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.blue[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono más pequeño
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_circle, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                "Nuevo Proceso",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Campos en orden: Nombre → Tamaño → DURACION → Llegada
              _campoTextoCompacto(nombreCtrl, "Nombre", Icons.person),
              const SizedBox(height: 12),
              _campoTextoCompacto(tamanoCtrl, "Tamaño (MB)", Icons.storage, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              // ← NUEVO CAMPO DURACION (entre Tamaño y Llegada)
              _campoTextoCompacto(duracionCtrl, "Duración (min)", Icons.timer, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _campoTextoCompacto(llegadaCtrl, "Llegada (HH:MM)", Icons.access_time),
              const SizedBox(height: 20),
              // Botones más pequeños
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Cancelar", style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (nombreCtrl.text.isEmpty || tamanoCtrl.text.isEmpty || duracionCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Complete todos los campos")),
                          );
                          return;
                        }
                        // ← AGREGADO 'duracionCtrl.text'
                        onAgregar(nombreCtrl.text, tamanoCtrl.text, duracionCtrl.text, llegadaCtrl.text);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text("Guardar", style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  DIALOGO ELIMINAR - SIN CAMBIOS
  static void mostrarDialogoEliminar(
    BuildContext context,
    Function(String, String) onEliminar,
  ) {
    final nombreCtrl = TextEditingController();
    final salidaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[50]!, Colors.red[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                "Eliminar Proceso",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _campoTextoCompacto(nombreCtrl, "Nombre", Icons.person),
              const SizedBox(height: 12),
              _campoTextoCompacto(salidaCtrl, "Salida (HH:MM)", Icons.schedule),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Cancelar", style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (nombreCtrl.text.isEmpty || salidaCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Complete campos")),
                          );
                          return;
                        }
                        onEliminar(nombreCtrl.text, salidaCtrl.text);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text("Eliminar", style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  CAMPO TEXTO COMPACTO - SIN CAMBIOS
  static Widget _campoTextoCompacto(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: Colors.blue[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          isDense: true,
        ),
      ),
    );
  }
}

class _BotonesAccionState extends State<BotonesAccion> {
  Opciones? _seleccion = Opciones.primerAjuste;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey[100]!, Colors.blueGrey[50]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //  ALGORITMO DE ASIGNACIÓN - SIN CAMBIOS
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: [
                const Text(
                  "Algoritmo de Asignación",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _radioButton(Opciones.primerAjuste, "Primer Ajuste", Icons.first_page),
                _radioButton(Opciones.mejorAjuste, "Mejor Ajuste", Icons.search),
              ],
            ),
          ),
          
          const SizedBox(height: 32),

          //  BOTONES COMPACTOS - SIN CAMBIOS
          Column(
            children: [
              _botonPrincipal(Icons.add_circle_outline, "Llegada", Colors.green,
                () => BotonesAccion.mostrarDialogoAgregar(context, widget.onAgregar)),
              const SizedBox(height: 20),
              _botonPrincipal(Icons.delete_outline, "Salida", Colors.red,
                () => BotonesAccion.mostrarDialogoEliminar(context, widget.onEliminar)),
              const SizedBox(height: 20),
              _botonPrincipal(Icons.refresh, "Reiniciar", Colors.orange, widget.onReinicio),
            ],
          ),
        ],
      ),
    );
  }

  // MÉTODOS AUXILIARES - SIN CAMBIOS
  Widget _radioButton(Opciones value, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: RadioListTile<Opciones>(
        title: Row(
          children: [
            Icon(icon, color: _seleccion == value ? Colors.blue[600] : Colors.grey),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
        value: value,
        groupValue: _seleccion,
        onChanged: (Opciones? newValue) {
          setState(() => _seleccion = newValue!);
          widget.onCambioOpcion(_seleccion!);
        },
        activeColor: Colors.blue[600],
        tileColor: Colors.transparent,
      ),
    );
  }

  Widget _botonPrincipal(IconData icon, String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 26),
        label: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
        ),
      ),
    );
  }
}