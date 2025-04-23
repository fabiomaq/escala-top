import 'package:flutter/material.dart';
import '../models/shift_model.dart';
import 'package:intl/intl.dart';

class CreateShiftScreen extends StatefulWidget {
  final DateTime? initialDate;
  
  const CreateShiftScreen({Key? key, this.initialDate}) : super(key: key);

  @override
  _CreateShiftScreenState createState() => _CreateShiftScreenState();
}

class _CreateShiftScreenState extends State<CreateShiftScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  String _selectedShiftPattern = '12x36';
  final _notesController = TextEditingController();
  
  ShiftType _shiftType = ShiftType.day;
  
  @override
  void initState() {
    super.initState();
    
    // Inicializar com a data fornecida ou a data atual
    final initialDate = widget.initialDate ?? DateTime.now();
    
    _startDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(initialDate),
    );
    
    _startTimeController = TextEditingController(
      text: '07:00', // Horário padrão
    );
    
    // Determinar o tipo de escala com base na hora
    _updateShiftType();
  }
  
  @override
  void dispose() {
    _startDateController.dispose();
    _startTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  void _updateShiftType() {
    // Extrair a hora do campo de texto
    final timeString = _startTimeController.text;
    if (timeString.isNotEmpty) {
      try {
        final parts = timeString.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          
          // Atualizar o tipo de escala com base na hora
          setState(() {
            if (hour <= 11) {
              _shiftType = ShiftType.day;
            } else {
              _shiftType = ShiftType.night;
            }
          });
        }
      } catch (e) {
        // Ignorar erros de parsing
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Escala'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data de início
                Text(
                  'Data e hora de início',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // Campo de data
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: 'Data',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _parseDate(_startDateController.text) ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() {
                              _startDateController.text = DateFormat('dd/MM/yyyy').format(date);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Data obrigatória';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    // Campo de hora
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Hora',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _parseTime(_startTimeController.text) ?? TimeOfDay(hour: 7, minute: 0),
                          );
                          if (time != null) {
                            setState(() {
                              _startTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              _updateShiftType();
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Hora obrigatória';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Tipo de escala
                Text(
                  'Tipo de escala',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedShiftPattern,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    '12x36',
                    '12x24/12x48',
                    '6x1',
                    '5x2',
                    'Personalizada',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedShiftPattern = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione um tipo de escala';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 24),
                
                // Informação sobre o tipo de escala (dia/noite)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _shiftType == ShiftType.day 
                      ? Colors.amber.withOpacity(0.2) 
                      : Colors.indigo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _shiftType == ShiftType.day ? Icons.wb_sunny : Icons.nightlight_round,
                        color: _shiftType == ShiftType.day ? Colors.amber[800] : Colors.indigo,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Esta é uma escala de ${_shiftType == ShiftType.day ? 'dia' : 'noite'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _shiftType == ShiftType.day ? Colors.amber[800] : Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Notas
                Text(
                  'Notas (opcional)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    hintText: 'Adicione informações adicionais sobre esta escala',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                
                SizedBox(height: 32),
                
                // Botão de salvar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Implementar lógica para salvar a escala
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Escala criada com sucesso!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Salvar Escala',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Função para converter string de data para DateTime
  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Ignorar erros de parsing
    }
    return null;
  }
  
  // Função para converter string de hora para TimeOfDay
  TimeOfDay? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Ignorar erros de parsing
    }
    return null;
  }
}
