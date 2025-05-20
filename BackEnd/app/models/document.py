from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import datetime
import uuid

class DocumentMetadata(BaseModel):
    """Metadata for a document."""
    title: str
    author: Optional[str] = "Unknown"
    created_at: Optional[datetime] = None
    page_count: Optional[int] = None
    slide_count: Optional[int] = None
    content_type: str
    file_size: Optional[int] = None

class DocumentStructureItem(BaseModel):
    """A structural element of a document (e.g., a heading)."""
    level: int
    heading: str
    page: Optional[int] = None
    slide: Optional[int] = None

class DocumentRequest(BaseModel):
    """Request model for document-based operations."""
    document_id: str
    additional_context: Optional[str] = None
    
class DocumentContent(BaseModel):
    """Content extracted from a document."""
    document_id: str = Field(default_factory=lambda: f"doc_{uuid.uuid4().hex[:8]}")
    filename: str
    file_path: str
    content: str
    metadata: DocumentMetadata
    structure: List[DocumentStructureItem]
    extracted_at: datetime = Field(default_factory=datetime.now)
    
class DocumentUploadResponse(BaseModel):
    """Response model for document upload."""
    document_id: str
    filename: str
    message: str
    content_extracted: bool = False
    metadata: Optional[Dict[str, Any]] = None
