// Dart models based on Python FastAPI models for document handling

class DocumentUploadResponse {
  final String documentId;
  final String fileName;
  final String status;

  DocumentUploadResponse({
    required this.documentId,
    required this.fileName,
    required this.status,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      documentId: json['document_id'] as String,
      fileName: json['file_name'] as String,
      status: json['status'] as String,
    );
  }
}

class DocumentDetailsResponse {
  final String documentId;
  final String fileName;
  final String status;
  final bool courseGenerated;

  DocumentDetailsResponse({
    required this.documentId,
    required this.fileName,
    required this.status,
    required this.courseGenerated,
  });

  factory DocumentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DocumentDetailsResponse(
      documentId: json['document_id'] as String,
      fileName: json['file_name'] as String,
      status: json['status'] as String,
      courseGenerated: json['course_generated'] as bool,
    );
  }
}

class DocumentCourseGenerationRequest {
  final String documentId;

  DocumentCourseGenerationRequest({
    required this.documentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
    };
  }
}

class CourseInfoForDocument {
  final String courseTitle;

  CourseInfoForDocument({
    required this.courseTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
    };
  }

  factory CourseInfoForDocument.fromJson(Map<String, dynamic> json) {
    return CourseInfoForDocument(
      courseTitle: json['course_title'] as String,
    );
  }
}

class DocumentModuleGenerationRequest {
  final String documentId;
  final CourseInfoForDocument courseInfo;
  final String moduleId;

  DocumentModuleGenerationRequest({
    required this.documentId,
    required this.courseInfo,
    required this.moduleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'course_info': courseInfo.toJson(),
      'module_id': moduleId,
    };
  }
}

class ModuleInfoForDocument {
  final String moduleId;
  final String moduleTitle;
  final List<String> lessons;

  ModuleInfoForDocument({
    required this.moduleId,
    required this.moduleTitle,
    required this.lessons,
  });

  Map<String, dynamic> toJson() {
    return {
      'module_id': moduleId,
      'module_title': moduleTitle,
      'lessons': lessons,
    };
  }

  factory ModuleInfoForDocument.fromJson(Map<String, dynamic> json) {
    return ModuleInfoForDocument(
      moduleId: json['module_id'] as String,
      moduleTitle: json['module_title'] as String,
      lessons: List<String>.from(json['lessons'] as List),
    );
  }
}

class DocumentLessonGenerationRequest {
  final String documentId;
  final ModuleInfoForDocument moduleInfo;
  final String lessonId;

  DocumentLessonGenerationRequest({
    required this.documentId,
    required this.moduleInfo,
    required this.lessonId,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'module_info': moduleInfo.toJson(),
      'lesson_id': lessonId,
    };
  }
}

class LessonInfoForDocumentQuiz {
  final String lessonId;

  LessonInfoForDocumentQuiz({
    required this.lessonId,
  });

  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
    };
  }

  factory LessonInfoForDocumentQuiz.fromJson(Map<String, dynamic> json) {
    return LessonInfoForDocumentQuiz(
      lessonId: json['lesson_id'] as String,
    );
  }
}

class DocumentQuizGenerationRequest {
  final String documentId;
  final LessonInfoForDocumentQuiz lessonInfo;
  final int questionCount;

  DocumentQuizGenerationRequest({
    required this.documentId,
    required this.lessonInfo,
    required this.questionCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'lesson_info': lessonInfo.toJson(),
      'question_count': questionCount,
    };
  }
}
