import 'package:flutter/material.dart';

enum ShiftType {
  day,
  night,
}

class Shift {
  final DateTime startDate;
  final DateTime endDate;
  final String shiftPattern; // 12x36, 12x24/12x48, 6x1, 5x2, etc.
  final ShiftType type;
  final String? notes;
  
  Shift({
    required this.startDate,
    required this.endDate,
    required this.shiftPattern,
    required this.type,
    this.notes,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'shiftPattern': shiftPattern,
      'type': type.toString(),
      'notes': notes,
    };
  }
  
  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      shiftPattern: map['shiftPattern'],
      type: map['type'] == 'ShiftType.day' ? ShiftType.day : ShiftType.night,
      notes: map['notes'],
    );
  }
  
  // Determina se é escala dia ou noite com base na hora de início
  static ShiftType determineShiftType(DateTime startTime) {
    final hour = startTime.hour;
    // Escala dia: início até 11h, escala noite: início até 23h
    if (hour <= 11) {
      return ShiftType.day;
    } else {
      return ShiftType.night;
    }
  }
}
