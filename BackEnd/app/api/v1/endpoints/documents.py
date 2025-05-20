import os
import aiofiles
from fastapi import APIRouter, File, UploadFile, HTTPException, status, BackgroundTasks
from app.models.document import DocumentUploadResponse, DocumentContent
from app.services.document_processing_service import DocumentProcessingService
from app.utils.id_generator import generate_id

router = APIRouter()

# In-memory store for document content (in a production app, this would be a database)
document_store = {}

# Initialize document processing service
document_service = DocumentProcessingService()

async def process_document_async(file_path: str, document_id: str):
    """Background task to process a document after upload"""
    try:
        # Extract content from the document
        document_data = await document_service.process_document(file_path)
        
        # Create DocumentContent object
        document_content = DocumentContent(
            document_id=document_id,
            filename=os.path.basename(file_path),
            file_path=file_path,
            content=document_data["content"],
            metadata=document_data["metadata"],
            structure=document_data["structure"]
        )
        
        # Store document content
        document_store[document_id] = document_content
        
        print(f"Document {document_id} processed successfully")
    except Exception as e:
        print(f"Error processing document {document_id}: {str(e)}")
        
        # Store error information in document_store to report to clients
        document_store[document_id] = {
            "error": True,
            "error_message": str(e),
            "document_id": document_id,
            "filename": os.path.basename(file_path),
            "file_path": file_path
        }

@router.post("/upload", response_model=DocumentUploadResponse)
async def upload_document(background_tasks: BackgroundTasks, file: UploadFile = File(...)):
    """
    Uploads a document to the server and processes it in the background.
    """
    if not file:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No file uploaded"
        )

    allowed_types = [
        "application/pdf",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ]

    # Also check file extension for local files whose content_type might not be correctly set
    file_ext = os.path.splitext(file.filename)[1].lower()
    valid_extensions = ['.pdf', '.pptx', '.docx']

    if file.content_type not in allowed_types and file_ext not in valid_extensions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid file type. Only PDF, PPTX, and DOCX are allowed."
        )

    # Generate a unique document ID
    document_id = generate_id("doc")

    try:
        # Create upload directory if it doesn't exist
        upload_dir = os.path.join("uploads", document_id)
        os.makedirs(upload_dir, exist_ok=True)
        
        # Save the uploaded file
        file_path = os.path.join(upload_dir, file.filename)
        
        # Use aiofiles for async file operations
        async with aiofiles.open(file_path, "wb") as f:
            content = await file.read()
            await f.write(content)
        
        # Schedule background task to process the document
        background_tasks.add_task(process_document_async, file_path, document_id)
        
        # Return response immediately without waiting for processing to complete
        return DocumentUploadResponse(
            document_id=document_id,
            filename=file.filename,
            message="File uploaded successfully. Content extraction in progress.",
            content_extracted=False
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error uploading file: {str(e)}"
        )

@router.get("/{document_id}")
async def get_document(document_id: str):
    """
    Retrieves document content by ID.
    """
    if document_id not in document_store:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Document with ID {document_id} not found or still processing"
        )
    
    document_data = document_store[document_id]
    
    # Check if there was an error during processing
    if isinstance(document_data, dict) and document_data.get("error", False):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error processing document: {document_data.get('error_message', 'Unknown error')}"
        )
    
    return document_data