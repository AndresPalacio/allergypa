import 'package:allergyp/models/alarmModel.dart';


abstract class ReminderEvent {}

class SetAlarms extends ReminderEvent {
  late List<AlarmDB> alarmList;

  SetAlarms(List<AlarmDB> alarms) {
    alarmList = alarms;
  }
}

class DeleteAlarm extends ReminderEvent {
  late int alarmIndex;

  DeleteAlarm(int index) {
    alarmIndex = index;
  }
}

class AddAlarm extends ReminderEvent {
  late AlarmDB newAlarm;

  AddAlarm(AlarmDB alarm) {
    newAlarm = alarm;
  }
}
