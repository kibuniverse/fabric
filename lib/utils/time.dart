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
