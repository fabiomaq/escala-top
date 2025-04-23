import 'package:flutter/material.dart';
import '../models/shift_model.dart';
import '../services/shift_pattern_service.dart';
import '../services/shift_database_service.dart';
import 'dart:async';

class ShiftGeneratorService {
  final ShiftDatabaseService _databaseService = ShiftDatabaseService();
  
  // Gera e salva uma série de escalas com base no padrão selecionado
  Future<bool> generateAndSaveShifts({
    required DateTime startDate,
    required TimeOfDay startTime,
    required String shiftPattern,
    required int durationInMonths,
    Map<String, dynamic>? customPattern,
    String? notes,
  }) async {
    try {
      // Gerar datas de trabalho
      final shiftDates = ShiftPatternService.generateShiftDates(
        startDate: startDate,
        startTime: startTime,
        shiftPattern: shiftPattern,
        durationInMonths: durationInMonths,
        customPattern: customPattern,
      );
      
      // Obter duração do turno em horas
      final shiftDurationHours = ShiftPatternService.getShiftDurationHours(shiftPattern);
      
      // Salvar cada data de trabalho no banco de dados
      for (var date in shiftDates) {
        final endDate = date.add(Duration(hours: shiftDurationHours));
        
        // Determinar se é escala dia ou noite
        final shiftType = Shift.determineShiftType(date);
        
        // Criar objeto Shift
        final shift = Shift(
          startDate: date,
          endDate: endDate,
          shiftPattern: shiftPattern,
          type: shiftType,
          notes: notes,
        );
        
        // Salvar no banco de dados
        await _databaseService.insertShift(shift);
      }
      
      // Limpar histórico antigo (manter apenas 1 ano)
      await _databaseService.cleanOldHistory();
      
      return true;
    } catch (e) {
      print('Erro ao gerar escalas: $e');
      return false;
    }
  }
  
  // Verifica se uma data específica tem escala
  Future<bool> hasShiftOnDate(DateTime date) async {
    final shift = await _databaseService.getShiftByDate(date);
    return shift != null;
  }
  
  // Obtém a escala para uma data específica
  Future<Shift?> getShiftForDate(DateTime date) async {
    return await _databaseService.getShiftByDate(date);
  }
  
  // Obtém todas as escalas para um mês específico
  Future<List<Shift>> getShiftsForMonth(int year, int month) async {
    return await _databaseService.getShiftsByMonth(year, month);
  }
  
  // Adiciona uma escala única
  Future<bool> addSingleShift({
    required DateTime startDate,
    required TimeOfDay startTime,
    required String shiftPattern,
    String? notes,
  }) async {
    try {
      final shiftDurationHours = ShiftPatternService.getShiftDurationHours(shiftPattern);
      
      // Converter TimeOfDay para DateTime
      final startDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        startTime.hour,
        startTime.minute,
      );
      
      final endDateTime = startDateTime.add(Duration(hours: shiftDurationHours));
      
      // Determinar se é escala dia ou noite
      final shiftType = Shift.determineShiftType(startDateTime);
      
      // Criar objeto Shift
      final shift = Shift(
        startDate: startDateTime,
        endDate: endDateTime,
        shiftPattern: shiftPattern,
        type: shiftType,
        notes: notes,
      );
      
      // Salvar no banco de dados
      await _databaseService.insertShift(shift);
      
      return true;
    } catch (e) {
      print('Erro ao adicionar escala: $e');
      return false;
    }
  }
  
  // Atualiza uma escala existente
  Future<bool> updateShift(Shift shift) async {
    try {
      await _databaseService.updateShift(shift);
      return true;
    } catch (e) {
      print('Erro ao atualizar escala: $e');
      return false;
    }
  }
  
  // Remove uma escala
  Future<bool> deleteShift(int id) async {
    try {
      await _databaseService.deleteShift(id);
      return true;
    } catch (e) {
      print('Erro ao remover escala: $e');
      return false;
    }
  }
}
