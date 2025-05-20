from fastapi import APIRouter, HTTPException, status, Depends
from typing import Dict, Any, Optional
from pydantic import BaseModel

from app.models.document import DocumentRequest
from app.models.course import CourseResponse
from app.models.module import ModuleResponse
from app.models.lesson import LessonResponse, QuizQuestion
from app.services.document_ai_service import DocumentAIService

# Import the document_store from the documents endpoint
from app.api.v1.endpoints.documents import document_store

router = APIRouter()

# Initialize the document AI service
document_ai_service = DocumentAIService()

class DocumentCourseRequest(DocumentRequest):
    """Request for generating a course from a document."""
    title_override: Optional[str] = None
    target_audience: Optional[str] = None
    complexity_level: Optional[str] = None

class DocumentModuleRequest(DocumentRequest):
    """Request for generating a module from a document."""
    course_info: Dict[str, Any]
    module_id: str

class DocumentLessonRequest(DocumentRequest):
    """Request for generating a lesson from a document."""
    module_info: Dict[str, Any]
    lesson_id: str

class DocumentQuizRequest(DocumentRequest):
    """Request for generating a quiz from a document."""
    lesson_info: Dict[str, Any]
    question_count: Optional[int] = 10

@router.post("/generate-course", response_model=CourseResponse)
async def generate_course_from_document(request: DocumentCourseRequest):
    """
    Generate a complete course structure from an uploaded document.
    """
    # Check if document exists
    if request.document_id not in document_store:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Document with ID {request.document_id} not found or still processing"
        )
    
    document = document_store[request.document_id]
    
    # Check if there was an error during document processing
    if isinstance(document, dict) and document.get("error", False):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Cannot generate course: {document.get('error_message', 'Error processing document')}"
        )
    
    # Prepare additional context based on request parameters
    additional_context = ""
    if request.title_override:
        additional_context += f"\nUse this title for the course: {request.title_override}"
    if request.target_audience:
        additional_context += f"\nTarget audience: {request.target_audience}"
    if request.complexity_level:
        additional_context += f"\nComplexity level: {request.complexity_level}"
    if request.additional_context:
        additional_context += f"\n{request.additional_context}"
    
    try:
        # Generate course from document
        course_response = await document_ai_service.generate_course_from_document(
            document, additional_context
        )
        return course_response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error generating course from document: {str(e)}"
        )

@router.post("/generate-module", response_model=ModuleResponse)
async def generate_module_from_document(request: DocumentModuleRequest):
    """
    Generate detailed module content from a document.
    """
    # Check if document exists
    if request.document_id not in document_store:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Document with ID {request.document_id} not found or still processing"
        )
    
    document = document_store[request.document_id]
    
    # Check if there was an error during document processing
    if isinstance(document, dict) and document.get("error", False):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Cannot generate module: {document.get('error_message', 'Error processing document')}"
        )
    
    try:
        # Generate module from document
        module_response = await document_ai_service.generate_module_from_document(
            document, request.course_info, request.module_id, request.additional_context
        )
        return module_response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error generating module from document: {str(e)}"
        )

@router.post("/generate-lesson", response_model=LessonResponse)
async def generate_lesson_from_document(request: DocumentLessonRequest):
    """
    Generate detailed lesson content from a document.
    """
    # Check if document exists
    if request.document_id not in document_store:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Document with ID {request.document_id} not found or still processing"
        )
    
    document = document_store[request.document_id]
    
    # Check if there was an error during document processing
    if isinstance(document, dict) and document.get("error", False):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Cannot generate lesson: {document.get('error_message', 'Error processing document')}"
        )
    
    try:
        # Generate lesson from document
        lesson_response = await document_ai_service.generate_lesson_from_document(
            document, request.module_info, request.lesson_id, request.additional_context
        )
        return lesson_response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error generating lesson from document: {str(e)}"
        )

@router.post("/generate-quiz", response_model=list[QuizQuestion])
async def generate_quiz_from_document(request: DocumentQuizRequest):
    """
    Generate a comprehensive quiz from document and lesson content.
    """
    # Check if document exists
    if request.document_id not in document_store:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Document with ID {request.document_id} not found or still processing"
        )
    
    document = document_store[request.document_id]
    
    # Check if there was an error during document processing
    if isinstance(document, dict) and document.get("error", False):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Cannot generate quiz: {document.get('error_message', 'Error processing document')}"
        )
    
    try:
        # Generate quiz from document
        quiz_questions = await document_ai_service.generate_quiz_from_document(
            document, request.lesson_info, request.additional_context, request.question_count
        )
        return quiz_questions
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error generating quiz from document: {str(e)}"
        )
