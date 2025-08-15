import 'package:flutter/material.dart';
import 'memory_game_screen.dart';

class MemoryGameSettingsScreen extends StatefulWidget {
  const MemoryGameSettingsScreen({Key? key}) : super(key: key);

  @override
  _MemoryGameSettingsScreenState createState() => _MemoryGameSettingsScreenState();
}

class _MemoryGameSettingsScreenState extends State<MemoryGameSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nController = TextEditingController(text: '4'); // Default value
  final _mController = TextEditingController(text: '3'); // Default value

  @override
  void dispose() {
    _nController.dispose();
    _mController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final n = int.parse(_nController.text);
      final m = int.parse(_mController.text);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MemoryGameScreen(
            sequenceLength: n,
            displayDurationInSeconds: m,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Sequence Length (n)',
                  hintText: 'e.g., 4',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  final n = int.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Please enter a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _mController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Display Time (m) in seconds',
                  hintText: 'e.g., 3',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  final m = int.tryParse(value);
                  if (m == null || m <= 0) {
                    return 'Please enter a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _startGame,
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
