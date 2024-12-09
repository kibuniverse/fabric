/// 时间相关的函数
library;

List<int> convertSecondsToHms(int v) {
  int hour = v ~/ 3600; // 计算小时数
  int minute = (v % 3600) ~/ 60; // 计算分钟数
  int second = v % 60; // 计算秒数

  return [hour, minute, second];
}

List<String> convertSecondsToHmsString(int v) {
  int hours = v ~/ 3600; // 计算小时数
  int minutes = (v % 3600) ~/ 60; // 计算分钟数
  int seconds = v % 60; // 计算秒数

  // 将每个值格式化为两位数
  String hour = hours.toString().padLeft(2, '0');
  String minute = minutes.toString().padLeft(2, '0');
  String second = seconds.toString().padLeft(2, '0');

  return [hour, minute, second];
}

/// 将时间戳转换为时间字符串, 字符串格式为 YYYY-MM-DD HH:MM:SS
String convertTimestampToTimeString(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // 使用toString方法和substring方法来格式化日期和时间
  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0');
  String day = dateTime.day.toString().padLeft(2, '0');
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String second = dateTime.second.toString().padLeft(2, '0');

  // 组合成最终的字符串格式
  return '$year-$month-$day $hour:$minute:$second';
}
