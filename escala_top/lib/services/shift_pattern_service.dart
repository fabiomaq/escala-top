import 'package:flutter/material.dart';
import 'dart:math';

class ShiftPatternService {
  // Padrões de escala pré-definidos
  static const String PATTERN_12X36 = '12x36';
  static const String PATTERN_12X24_12X48 = '12x24/12x48';
  static const String PATTERN_6X1 = '6x1';
  static const String PATTERN_5X2 = '5x2';
  static const String PATTERN_CUSTOM = 'Personalizada';

  // Gera uma lista de datas de trabalho com base no padrão de escala
  static List<DateTime> generateShiftDates({
    required DateTime startDate,
    required TimeOfDay startTime,
    required String shiftPattern,
    required int durationInMonths,
    Map<String, dynamic>? customPattern,
  }) {
    // Converter TimeOfDay para horas e minutos
    final startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );

    // Data final (baseada na duração em meses)
    final endDate = DateTime(
      startDate.year,
      startDate.month + durationInMonths,
      startDate.day,
    );

    List<DateTime> shiftDates = [];
    DateTime currentDate = startDateTime;

    switch (shiftPattern) {
      case PATTERN_12X36:
        // Escala 12x36: 12 horas de trabalho, 36 horas de descanso
        while (currentDate.isBefore(endDate)) {
          shiftDates.add(currentDate);
          // Próxima data: adicionar 48 horas (12 trabalho + 36 descanso)
          currentDate = currentDate.add(Duration(hours: 48));
        }
        break;

      case PATTERN_12X24_12X48:
        // Escala 12x24/12x48: alternância entre 12h trabalho, 24h descanso e 12h trabalho, 48h descanso
        bool isFirstCycle = true;
        while (currentDate.isBefore(endDate)) {
          shiftDates.add(currentDate);
          
          if (isFirstCycle) {
            // Primeiro ciclo: 12h trabalho + 24h descanso = 36h
            currentDate = currentDate.add(Duration(hours: 36));
          } else {
            // Segundo ciclo: 12h trabalho + 48h descanso = 60h
            currentDate = currentDate.add(Duration(hours: 60));
          }
          
          isFirstCycle = !isFirstCycle; // Alternar entre os ciclos
        }
        break;

      case PATTERN_6X1:
        // Escala 6x1: 6 dias de trabalho, 1 dia de folga
        while (currentDate.isBefore(endDate)) {
          // Adicionar 6 dias de trabalho consecutivos
          for (int i = 0; i < 6 && currentDate.isBefore(endDate); i++) {
            shiftDates.add(currentDate);
            currentDate = currentDate.add(Duration(days: 1));
          }
          // Pular 1 dia de folga
          currentDate = currentDate.add(Duration(days: 1));
        }
        break;

      case PATTERN_5X2:
        // Escala 5x2: 5 dias de trabalho, 2 dias de folga (típico de segunda a sexta)
        while (currentDate.isBefore(endDate)) {
          // Verificar se é dia útil (1 = segunda, 5 = sexta)
          int weekday = currentDate.weekday;
          if (weekday >= 1 && weekday <= 5) {
            shiftDates.add(currentDate);
          }
          // Avançar para o próximo dia
          currentDate = currentDate.add(Duration(days: 1));
        }
        break;

      case PATTERN_CUSTOM:
        // Escala personalizada
        if (customPattern != null) {
          int workDays = customPattern['workDays'] ?? 1;
          int restDays = customPattern['restDays'] ?? 1;
          
          while (currentDate.isBefore(endDate)) {
            // Adicionar dias de trabalho
            for (int i = 0; i < workDays && currentDate.isBefore(endDate); i++) {
              shiftDates.add(currentDate);
              currentDate = currentDate.add(Duration(days: 1));
            }
            // Pular dias de descanso
            currentDate = currentDate.add(Duration(days: restDays));
          }
        }
        break;
    }

    return shiftDates;
  }

  // Calcula a duração de um turno com base no padrão de escala
  static int getShiftDurationHours(String shiftPattern) {
    switch (shiftPattern) {
      case PATTERN_12X36:
      case PATTERN_12X24_12X48:
        return 12;
      case PATTERN_6X1:
      case PATTERN_5X2:
        return 8; // Padrão de 8 horas para escalas diárias
      case PATTERN_CUSTOM:
        return 8; // Valor padrão para escala personalizada
      default:
        return 8;
    }
  }

  // Verifica se uma data específica é um dia de trabalho com base no padrão de escala
  static bool isWorkDay({
    required DateTime referenceDate,
    required DateTime targetDate,
    required String shiftPattern,
    Map<String, dynamic>? customPattern,
  }) {
    // Gerar datas de trabalho por 3 meses a partir da data de referência
    final workDates = generateShiftDates(
      startDate: referenceDate,
      startTime: TimeOfDay(hour: referenceDate.hour, minute: referenceDate.minute),
      shiftPattern: shiftPattern,
      durationInMonths: 3,
      customPattern: customPattern,
    );

    // Verificar se a data alvo está na lista de datas de trabalho
    return workDates.any((date) =>
      date.year == targetDate.year &&
      date.month == targetDate.month &&
      date.day == targetDate.day
    );
  }
}
