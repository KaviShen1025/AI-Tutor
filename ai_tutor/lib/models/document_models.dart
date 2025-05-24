// Dart models for document processing

class DocumentUploadResponse {
  final String documentId;
  final String filename;
  final String message;
  final bool contentExtracted;

  DocumentUploadResponse({
    required this.documentId,
    required this.filename,
    required this.message,
    required this.contentExtracted,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      documentId: json['document_id'] as String,
      filename: json['filename'] as String,
      message: json['message'] as String,
      contentExtracted: json['content_extracted'] as bool? ?? false, // Handle potential null
    );
  }
}

class DocumentContent {
  final String documentId;
  final String filename;
  final String filePath;
  final String content;
  final Map<String, dynamic> metadata;
  final dynamic structure; // Can be Map or List

  DocumentContent({
    required this.documentId,
    required this.filename,
    required this.filePath,
    required this.content,
    required this.metadata,
    this.structure,
  });

  factory DocumentContent.fromJson(Map<String, dynamic> json) {
    return DocumentContent(
      documentId: json['document_id'] as String,
      filename: json['filename'] as String,
      filePath: json['file_path'] as String,
      content: json['content'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {}, // Handle potential null
      structure: json['structure'], // Allow null
    );
  }
}
