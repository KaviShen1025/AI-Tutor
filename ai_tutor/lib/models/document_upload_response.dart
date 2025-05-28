import 'dart:convert';

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
      contentExtracted: json['content_extracted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'filename': filename,
      'message': message,
      'content_extracted': contentExtracted,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
