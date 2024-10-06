class Grade {
  final String patient;
  final String homeworkId;
  final String grade;
  final String details;
  final String finishTime;
  final String myTherapist;
  final List<String> audioPathList;

  Grade({
    required this.patient,
    required this.homeworkId,
    required this.grade,
    required this.details,
    required this.finishTime,
    required this.myTherapist,
    required this.audioPathList
  });

  Map<String, dynamic> toMap() {
    return {
      'patient': patient,
      'homeworkId': homeworkId,
      'grade': grade,
      'details': details,
      'finishTime': finishTime,
      'myTherapist': myTherapist,
      'audioPathList':audioPathList,
    };
  }
}