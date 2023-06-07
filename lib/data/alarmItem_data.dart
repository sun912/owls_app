class AlarmItemData {
  final String itemId;
  final DateTime occurrenceTime;
  final String contents;
  var isChecked = false;

  AlarmItemData.origin({
    required this.itemId,
    required this.occurrenceTime,
    required this.contents,
  });
}
