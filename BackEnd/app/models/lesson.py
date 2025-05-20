from pydantic import BaseModel
from typing import List, Dict, Optional

class LessonRequest(BaseModel):
    course_title: str
    module_title: str
    lesson_title: str
    lesson_objective: str

class LessonResponse(BaseModel):
    lesson_id: Optional[str] = None
    lesson_title: Optional[str] = None
    learning_objectives: Optional[List[str]] = None
    content: Optional[Dict[str, str]] = None
    quiz: Optional[List['QuizQuestion']] = None
    lesson_content: Optional[str] = None  # Keep backward compatibility

class QuizQuestion(BaseModel):
    question: str
    options: List[str]
    correct_answer: str
    explanation: str

class QuizResponse(BaseModel):
    quiz: List[QuizQuestion]
