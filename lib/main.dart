import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var capacidad = 0;
  var aforo = 0;
  final List<String> historial = [];
  final TextEditingController _capacidadController = TextEditingController();
  bool _inputBloqueado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control de Aforo – Ferry Cozumel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TODO: Imagen ilustrativa
            _buildBarco(),
            const SizedBox(height: 16),
            // TODO: Campo capacidad + botón aplicar
            _buildInputCapacidad(),
            const SizedBox(height: 16),
            // TODO: Panel de estado (aforo, barra, semáforo)
            _buildPanelEstado(),
            const SizedBox(height: 16),
            // TODO: Botones de control (+/-)
            _buildBotones(),
            const SizedBox(height: 16),
            // TODO: Historial de eventos (Expanded + ListView)
            _buildHistorial(),
          ],
        ),
      ),
    );
  }

  //* Barco
  Widget _buildBarco() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'https://us.123rf.com/450wm/sudowoodo/sudowoodo1710/sudowoodo171000014/87610947-cute-cartoon-retro-riverboat-drawing-classic-american-passenger-ferry-ship-vector-illustration.jpg',
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }

  //* Input para la capaciadd
  Widget _buildInputCapacidad() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _capacidadController,
            enabled: !_inputBloqueado,
            decoration: const InputDecoration(
              labelText: "Capacidad máxima",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              capacidad = int.tryParse(_capacidadController.text) ?? 0;
              aforo = 0;
              historial.clear();
              _inputBloqueado = true;
            });
          },
          child: const Text("Aplicar"),
        ),
      ],
    );
  }

  //* Panel de estado
  Widget _buildPanelEstado() {
    double porcentaje = capacidad > 0 ? aforo / capacidad : 0;
    return Column(
      children: [
        Text("Aforo: $aforo / $capacidad"),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: porcentaje),
        const SizedBox(height: 16),
        _buildSemaforo(porcentaje),
      ],
    );
  }

  //* Semáforo
  Widget _buildSemaforo(double porcentaje) {
    Color verde = Colors.green.withOpacity(porcentaje < 0.60 ? 1 : 0.3);
    Color amarillo = Colors.yellow.withOpacity( porcentaje >= 0.60 && porcentaje < 0.90 ? 1 : 0.3, );
    Color rojo = Colors.red.withOpacity(porcentaje >= 0.90 ? 1 : 0.3);

    return Column(
      children: [_buildLuz(rojo), _buildLuz(amarillo), _buildLuz(verde)],
    );
  }

  Widget _buildLuz(Color color) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }

  //* Botones de agregar / quitar pasejaros
  Widget _buildBotones() {
    return Wrap(
      spacing: 8,
      children: [
        _buildBotonControl("+1", 1),
        _buildBotonControl("+2", 2),
        _buildBotonControl("+5", 5),
        _buildBotonControl("-1", -1),
        _buildBotonControl("-5", -5),
        ElevatedButton(
          onPressed: () {
            setState(() {
              aforo = 0;
              historial.add("Reinicio → Aforo: $aforo/$capacidad");
            });
          },
          child: const Text("Reiniciar"),
        ),
      ],
    );
  }

  Widget _buildBotonControl(String label, int cambio) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          var nuevo = aforo + cambio;
          if (nuevo >= 0 && nuevo <= capacidad) {
            aforo = nuevo;
            historial.add(
              (cambio > 0 ? "Entraron " : "Salieron ") + "$cambio → Aforo: $aforo/$capacidad",
            );
          }
        });
      },
      child: Text(label),
    );
  }

  //* hISTORIAL
  Widget _buildHistorial() {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: historial.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Text(historial[index]),
            ),
          );
        },
      ),
    );
  }
}
