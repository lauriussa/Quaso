import 'dart:collection';

import 'package:quaso/constants.dart';
import 'package:quaso/habits/habit.dart';

class StatisticsData {
  String title = "";
  int topStreak = 0;
  int actualStreak = 0;
  int checks = 0;
  int skips = 0;
  int fails = 0;
  SplayTreeMap<int, Map<DayType, List<int>>> monthlyCheck = SplayTreeMap();
}

class OverallStatisticsData {
  int checks = 0;
  int skips = 0;
  int fails = 0;
}

class AllStatistics {
  OverallStatisticsData total = OverallStatisticsData();
  List<StatisticsData> habitsData = [];
}

class Statistics {
  static Future<AllStatistics> calculateStatistics(List<Habit>? habits) async {
    AllStatistics stats = AllStatistics();

    if (habits == null) return stats;

    for (var habit in habits) {
      var stat = StatisticsData();
      stat.title = habit.habitData.title;

      bool usingTwoDayRule = false;

      var lastDay = habit.habitData.events.firstKey();

      habit.habitData.events.forEach(
        (key, value) {
          if (value[0] != null && value[0] != DayType.clear) {
            if (key.difference(lastDay!).inDays > 1) {
              stat.actualStreak = 0;
            }

            switch (value[0]) {
              case DayType.check:
                stat.checks++;
                stat.actualStreak++;
                if (stat.actualStreak > stat.topStreak) {
                  stat.topStreak = stat.actualStreak;
                }
                usingTwoDayRule = false;
                break;
              case DayType.skip:
                stat.skips++;
                if (usingTwoDayRule) {
                  stat.actualStreak = 0;
                }
                break;
              case DayType.fail:
                stat.fails++;
                if (habit.habitData.twoDayRule) {
                  if (usingTwoDayRule) {
                    stat.actualStreak = 0;
                  } else {
                    usingTwoDayRule = true;
                  }
                } else {
                  stat.actualStreak = 0;
                }
                break;
            }

            generateYearIfNull(stat, key.year);

            if (value[0] != DayType.clear) {
              stat.monthlyCheck[key.year]![value[0]]![key.month - 1]++;
            }

            lastDay = key;
          }
        },
      );

      generateYearIfNull(stat, DateTime.now().year);
      stats.habitsData.add(stat);
      stats.total.checks += stat.checks;
      stats.total.fails += stat.fails;
      stats.total.skips += stat.skips;
    }
    return stats;
  }

  static generateYearIfNull(StatisticsData stat, int year) {
    if (stat.monthlyCheck[year] == null) {
      stat.monthlyCheck[year] = {
        DayType.check: List.filled(12, 0),
        DayType.skip: List.filled(12, 0),
        DayType.fail: List.filled(12, 0),
      };
    }
  }
}
