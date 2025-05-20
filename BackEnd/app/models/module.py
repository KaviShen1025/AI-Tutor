from pydantic import BaseModel
from typing import List

class ModuleRequest(BaseModel):
    course_title: str
    course_description: str
    module_title: str
    module_summary: str

class LessonInfo(BaseModel):
    lesson_id: str
    lesson_title: str
    lesson_summary: str  # Changed from lesson_objective to match usage in document_ai_service.py

class ModuleResponse(BaseModel):
    module_id: str  # Added missing field
    module_title: str  # Added missing field
    module_description: str  # Added missing field
    learning_objectives: List[str]  # Added missing field
    estimated_time: str  # Added missing field 
    lessons: List[LessonInfo]
