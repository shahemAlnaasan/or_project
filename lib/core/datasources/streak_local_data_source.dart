// import 'package:cal/core/local_models/streak_model/streak_model.dart';
// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';
// import 'package:isar/isar.dart';

// import '../../common/utils/date_helper.dart';

// @injectable
// class StreakLocalDataSource {
//   final Isar _isar;

//   StreakLocalDataSource(this._isar);

//   Future<void> saveStreak(StreakModel streak) async {
//     final existing = await _isar.streakModels
//         .filter()
//         .streakDateBetween(DateTime(streak.streakDate.year, streak.streakDate.month, streak.streakDate.day), DateTime(streak.streakDate.year, streak.streakDate.month, streak.streakDate.day + 1))
//         .findFirst();

//     if (existing == null) {
//       await _isar.writeTxn(() async {
//         await _isar.streakModels.put(streak);
//       });
//     } else {
//       await _isar.writeTxn(() async {
//         await _isar.streakModels.delete(existing.id);
//       });
//       await _isar.writeTxn(() async {
//         await _isar.streakModels.put(streak);
//       });
//     }
//   }

//   Future<List<StreakModel>> getStreak(Locale locale) async {
//     List<List<Map<String, String>>> allWeeks = DateHelper.getPastFourWeeks(locale);

//     List<DateTime> allDates = allWeeks.expand((week) => week.map((day) => DateTime.parse(day['fullDate']!))).toList();

//     List<StreakModel> existingStreaks = await _isar.streakModels.where().findAll();

//     Map<DateTime, StreakModel> existingMap = {for (var streak in existingStreaks) DateTime(streak.streakDate.year, streak.streakDate.month, streak.streakDate.day): streak};

//     List<StreakModel> finalStreaks = List.generate(allDates.length, (index) {
//       return existingMap[allDates[index]] ?? StreakModel(streakDate: allDates[index], hasAction: false);
//     });

//     return finalStreaks;
//   }
// }
