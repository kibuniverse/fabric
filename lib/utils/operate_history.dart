/// 操作历史模块相关的工具
library;

/// 历史操作和展示文案映射的函数
String getOperateHistoryText(String type) {
  switch (type) {
    case "Operation.add":
      return "行+1";
    case "Operation.minus":
      return "行-1";
    case "Operation.reset":
      return "重置";
    default:
      return "未知操作";
  }
}
