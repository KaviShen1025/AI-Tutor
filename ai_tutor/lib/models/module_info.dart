import 'dart:convert';

class ModuleInfo {
  final String moduleId;
  final String moduleTitle;
  final String moduleSummary;

  ModuleInfo({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleSummary,
  });

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    return ModuleInfo(
      moduleId: json['module_id'] as String,
      moduleTitle: json['module_title'] as String,
      moduleSummary: json['module_summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module_id': moduleId,
      'module_title': moduleTitle,
      'module_summary': moduleSummary,
    };
  }
}
