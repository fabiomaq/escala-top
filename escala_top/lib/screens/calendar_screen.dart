import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/shift_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isMonthView = true; // true para visualização mensal, false para anual
  
  // Lista de meses para visualização anual
  final List<String> _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isMonthView 
          ? DateFormat('MMMM yyyy', 'pt_BR').format(_selectedDate)
          : 'Calendário ${_selectedDate.year}'),
        actions: [
          // Botão para alternar entre visualização mensal e anual
          IconButton(
            icon: Icon(_isMonthView ? Icons.calendar_view_month : Icons.calendar_month),
            onPressed: () {
              setState(() {
                _isMonthView = !_isMonthView;
              });
            },
            tooltip: _isMonthView ? 'Visualização anual' : 'Visualização mensal',
          ),
          // Botão para adicionar nova escala
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navegar para tela de criação de escala
              Navigator.pushNamed(context, '/create_shift');
            },
            tooltip: 'Adicionar escala',
          ),
        ],
      ),
      body: _isMonthView ? _buildMonthView() : _buildYearView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Botão para gerar escala automaticamente
          _showGenerateShiftDialog();
        },
        child: Icon(Icons.auto_awesome),
        tooltip: 'Gerar escala',
      ),
    );
  }

  Widget _buildMonthView() {
    return Column(
      children: [
        // Cabeçalho com navegação entre meses
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month - 1,
                      _selectedDate.day,
                    );
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy', 'pt_BR').format(_selectedDate),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month + 1,
                      _selectedDate.day,
                    );
                  });
                },
              ),
            ],
          ),
        ),
        
        // Dias da semana
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _weekDayLabel('D'),
              _weekDayLabel('S'),
              _weekDayLabel('T'),
              _weekDayLabel('Q'),
              _weekDayLabel('Q'),
              _weekDayLabel('S'),
              _weekDayLabel('S'),
            ],
          ),
        ),
        
        // Grade do calendário
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: _getDaysInMonth(_selectedDate.year, _selectedDate.month) + _getFirstDayOfMonth(_selectedDate.year, _selectedDate.month),
            itemBuilder: (context, index) {
              // Calcular o dia real com base no índice e no primeiro dia do mês
              final firstDayOffset = _getFirstDayOfMonth(_selectedDate.year, _selectedDate.month);
              
              // Dias vazios antes do primeiro dia do mês
              if (index < firstDayOffset) {
                return Container();
              }
              
              final day = index - firstDayOffset + 1;
              final date = DateTime(_selectedDate.year, _selectedDate.month, day);
              
              // Verificar se o dia tem escala (simulação)
              final hasShift = _hasShift(date);
              final shiftType = _getShiftType(date);
              
              return _buildDayCell(day, date, hasShift, shiftType);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildYearView() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, month, 1);
              _isMonthView = true;
            });
          },
          child: Card(
            elevation: 4,
            child: Column(
              children: [
                // Cabeçalho do mês
                Container(
                  padding: EdgeInsets.all(8),
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: Text(
                    _months[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // Mini calendário do mês
                Expanded(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: _getDaysInMonth(_selectedDate.year, month) + _getFirstDayOfMonth(_selectedDate.year, month),
                    itemBuilder: (context, dayIndex) {
                      final firstDayOffset = _getFirstDayOfMonth(_selectedDate.year, month);
                      
                      if (dayIndex < firstDayOffset) {
                        return Container();
                      }
                      
                      final day = dayIndex - firstDayOffset + 1;
                      final date = DateTime(_selectedDate.year, month, day);
                      
                      // Verificar se o dia tem escala (simulação)
                      final hasShift = _hasShift(date);
                      
                      return Container(
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: hasShift ? Theme.of(context).primaryColor.withOpacity(0.3) : null,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: hasShift ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCell(int day, DateTime date, bool hasShift, ShiftType? shiftType) {
    final isToday = _isToday(date);
    
    return GestureDetector(
      onTap: () {
        // Ao clicar em um dia, mostrar detalhes ou permitir adicionar escala
        if (hasShift) {
          _showShiftDetails(date);
        } else {
          _showAddShiftDialog(date);
        }
      },
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: hasShift 
            ? (shiftType == ShiftType.day 
                ? Colors.amber.withOpacity(0.3) 
                : Colors.indigo.withOpacity(0.3))
            : null,
          border: isToday 
            ? Border.all(color: Theme.of(context).primaryColor, width: 2) 
            : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: TextStyle(
                fontWeight: isToday || hasShift ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (hasShift)
              Text(
                shiftType == ShiftType.day ? 'dia' : 'noite',
                style: TextStyle(
                  fontSize: 10,
                  color: shiftType == ShiftType.day ? Colors.amber[800] : Colors.indigo,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _weekDayLabel(String label) {
    return Container(
      width: 30,
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Funções auxiliares para o calendário
  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _getFirstDayOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday % 7;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Simulação de dados de escala (substituir por dados reais posteriormente)
  bool _hasShift(DateTime date) {
    // Simulação: dias pares têm escala
    return date.day % 2 == 0;
  }

  ShiftType? _getShiftType(DateTime date) {
    if (!_hasShift(date)) return null;
    
    // Simulação: dias divisíveis por 4 são escalas noturnas, outros são diurnas
    return date.day % 4 == 0 ? ShiftType.night : ShiftType.day;
  }

  // Diálogos
  void _showShiftDetails(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes da Escala'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data: ${DateFormat('dd/MM/yyyy', 'pt_BR').format(date)}'),
            SizedBox(height: 8),
            Text('Tipo: ${_getShiftType(date) == ShiftType.day ? 'Diurna' : 'Noturna'}'),
            SizedBox(height: 8),
            Text('Padrão: 12x36'), // Simulação
            SizedBox(height: 8),
            Text('Horário: ${_getShiftType(date) == ShiftType.day ? '07:00 - 19:00' : '19:00 - 07:00'}'), // Simulação
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar edição de escala
            },
            child: Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _showAddShiftDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Escala'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data: ${DateFormat('dd/MM/yyyy', 'pt_BR').format(date)}'),
            SizedBox(height: 16),
            Text('Selecione o tipo de escala:'),
            SizedBox(height: 8),
            _buildShiftTypeButton('12x36', Icons.access_time),
            _buildShiftTypeButton('12x24/12x48', Icons.access_time),
            _buildShiftTypeButton('6x1', Icons.access_time),
            _buildShiftTypeButton('5x2', Icons.access_time),
            _buildShiftTypeButton('Personalizada', Icons.edit),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftTypeButton(String label, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // Implementar adição de escala com o tipo selecionado
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _showGenerateShiftDialog() {
    final startDateController = TextEditingController();
    final startTimeController = TextEditingController();
    String selectedShiftPattern = '12x36';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Gerar Escala'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selecione o padrão de escala:'),
              SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedShiftPattern,
                isExpanded: true,
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
                    selectedShiftPattern = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Data de início',
                  hintText: 'DD/MM/AAAA',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    startDateController.text = DateFormat('dd/MM/yyyy').format(date);
                  }
                },
              ),
              SizedBox(height: 8),
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora de início',
                  hintText: 'HH:MM',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    startTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementar geração de escala
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Escala gerada com sucesso!')),
                );
              },
              child: Text('Gerar'),
            ),
          ],
        ),
      ),
    );
  }
}
