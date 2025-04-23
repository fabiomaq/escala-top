import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/shift_generator_service.dart';
import '../models/shift_model.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ShiftGeneratorService _shiftService = ShiftGeneratorService();
  List<Shift> _shifts = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
  
  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Carregar histórico de escalas dos últimos 12 meses
      final now = DateTime.now();
      final shifts = await _shiftService.getShiftsForMonth(now.year, now.month);
      
      setState(() {
        _shifts = shifts;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar histórico: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Escalas'),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _shifts.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhuma escala no histórico',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'As escalas trabalhadas aparecerão aqui',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/create_shift');
            },
            icon: Icon(Icons.add),
            label: Text('Criar Escala'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistoryList() {
    // Agrupar escalas por mês
    Map<String, List<Shift>> shiftsByMonth = {};
    
    for (var shift in _shifts) {
      final monthYear = DateFormat('MMMM yyyy', 'pt_BR').format(shift.startDate);
      if (!shiftsByMonth.containsKey(monthYear)) {
        shiftsByMonth[monthYear] = [];
      }
      shiftsByMonth[monthYear]!.add(shift);
    }
    
    return ListView.builder(
      itemCount: shiftsByMonth.length,
      itemBuilder: (context, index) {
        final monthYear = shiftsByMonth.keys.elementAt(index);
        final monthShifts = shiftsByMonth[monthYear]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do mês
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                monthYear,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Lista de escalas do mês
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: monthShifts.length,
              itemBuilder: (context, i) {
                final shift = monthShifts[i];
                return _buildShiftItem(shift);
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildShiftItem(Shift shift) {
    final startDate = DateFormat('dd/MM/yyyy', 'pt_BR').format(shift.startDate);
    final startTime = DateFormat('HH:mm', 'pt_BR').format(shift.startDate);
    final endTime = DateFormat('HH:mm', 'pt_BR').format(shift.endDate);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: shift.type == ShiftType.day 
            ? Colors.amber.withOpacity(0.2) 
            : Colors.indigo.withOpacity(0.2),
          child: Icon(
            shift.type == ShiftType.day ? Icons.wb_sunny : Icons.nightlight_round,
            color: shift.type == ShiftType.day ? Colors.amber[800] : Colors.indigo,
          ),
        ),
        title: Text(
          '$startDate - ${shift.shiftPattern}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Horário: $startTime - $endTime'),
            if (shift.notes != null && shift.notes!.isNotEmpty)
              Text(
                'Notas: ${shift.notes}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: Text(
          shift.type == ShiftType.day ? 'Dia' : 'Noite',
          style: TextStyle(
            color: shift.type == ShiftType.day ? Colors.amber[800] : Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Mostrar detalhes da escala
        },
      ),
    );
  }
}
