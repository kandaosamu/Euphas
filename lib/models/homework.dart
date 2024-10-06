class Homework{
  final String therapist;
  final String patient;
  final String category;
  final String subCategory;
  final String level;
  final int trial;
  final List<String> content;
  final int toDoTimes;
  final int doneTimes;

  const Homework({
    required this.therapist,
    required this.patient,
    required this.category,
    required this.subCategory,
    required this.level,
    required this.trial,
    required this.content,
    required this.toDoTimes,
    required this.doneTimes
  });

  Map<String, dynamic> toMap(){
    return {
      'therapist': therapist,
      'patient': patient,
      'category': category,
      'subCategory': subCategory,
      'level': level,
      'trial': trial,
      'content':content,
      'toDoTimes': toDoTimes,
      'doneTimes': doneTimes,
    };
  }
}