class CurrentTask {
  final String title;
  final List<String> members;
  final bool isCompleted;
  final int timerDays;
  final int timerHours;
  final int timerMinutes;
  final String startTime;

  CurrentTask({
    required this.title,
    required this.members,
    this.isCompleted = false,
    required this.timerDays,
    required this.timerHours,
    required this.timerMinutes,
    required this.startTime,
  });

  // Convert a Task object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'members': members,
      'isCompleted': isCompleted,
      'timerDays': timerDays,
      'timerHours': timerHours,
      'timerMinutes': timerMinutes,
      'startTime': startTime,
    };
  }
}
