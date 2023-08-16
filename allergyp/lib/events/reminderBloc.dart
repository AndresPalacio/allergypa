import 'package:allergyp/events/reminderEvent.dart';
import 'package:allergyp/models/alarmModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderBloc extends Bloc<ReminderEvent, List<AlarmDB>> {
  ReminderBloc(): super([]);

  @override
  List<AlarmDB> get initialState => [];

  @override
  Stream<List<AlarmDB>?> mapEventToState(ReminderEvent event) async* {
    if (event is SetAlarms) {
      yield event.alarmList;
    } else if (event is AddAlarm) {
      List<AlarmDB> newState = List.from(state);
            
      if (event.newAlarm != null) {
        newState.add(event.newAlarm);
      }
      yield newState;
    } else if (event is DeleteAlarm) {
      List<AlarmDB> newState = List.from(state);
      newState.removeAt(event.alarmIndex);
      yield newState;
    }
  }
}
