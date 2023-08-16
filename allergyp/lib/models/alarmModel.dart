
class AlarmDB {
  int id;
  int pushID;
  String date;
  String state;
  String medicine;
  String dosage;

  AlarmDB({
    required this.id,
    required this.state,
    required this.date,
    required this.medicine,
    required this.dosage,
    required this.pushID,
  });

}
