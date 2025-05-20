from typing import Dict, Any, List, Optional
import json
from fastapi import HTTPException

from app.services.ai_service import AIService
from app.models.document import DocumentContent
from app.models.course import CourseResponse, ModuleInfo
from app.models.module import ModuleResponse, LessonInfo
from app.models.lesson import LessonResponse, QuizQuestion

class DocumentAIService:
    """Service for generating educational content based on document content."""
    
    def __init__(self):
        """Initialize the document AI service."""
        self.ai_service = AIService()
    
    async def generate_course_from_document(
        self, document: DocumentContent, additional_context: Optional[str] = None
    ) -> CourseResponse:
        """
        Generate a complete course structure from a document.
        
        Args:
            document: The processed document content
            additional_context: Optional additional context or instructions
            
        Returns:
            A complete course structure including modules
        """
        # Extract key information from the document
        doc_content = document.content
        doc_structure = document.structure
        doc_metadata = document.metadata
        
        # Use the first 10000 characters of content for the initial course generation (to avoid token limits)
        context_text = doc_content[:10000]
        
        # For PDF or PPTX with many headings, summarize the structure
        structure_text = ""
        if doc_structure and len(doc_structure) > 0:
            headings = [item.heading for item in doc_structure[:20]]  # Get first 20 headings
            structure_text = "\nDocument structure includes these key topics:\n" + "\n".join(
                [f"- {heading}" for heading in headings]
            )
        
        additional_instructions = additional_context if additional_context else ""
        
        # Create prompt for course generation
        prompt = f"""
        Generate a comprehensive course based on the following document content.
        
        DOCUMENT TITLE: {doc_metadata.title}
        DOCUMENT AUTHOR: {doc_metadata.author}
        
        DOCUMENT CONTENT:
        {context_text}
        
        {structure_text}
        
        {additional_instructions}
        
        Create a structured course with the following:
        1. A clear and engaging course title that reflects the document content
        2. A comprehensive course description (3-5 sentences)
        3. A compelling course introduction (1-2 paragraphs)
        4. 3-8 logical modules that cover the document content comprehensively
        
        For each module provide:
        - A clear title
        - A brief summary (2-3 sentences)
        
        The modules should follow the logical structure of the document where possible.
        
        Format the response as a JSON object with the following structure:
        {{
          "course_title": "...",
          "course_description": "...",
          "course_introduction": "...",
          "modules": [
            {{
              "module_title": "...",
              "module_summary": "..."
            }}
          ]
        }}
        """
        
        try:
            # Generate course structure using AI
            course_json = await self.ai_service.generate_structured_content(prompt)
            
            # Add module_id to each module
            from app.utils.id_generator import generate_id
            
            modules_with_ids = []
            for module in course_json["modules"]:
                module_with_id = ModuleInfo(
                    module_id=generate_id("mod"),
                    module_title=module["module_title"],
                    module_summary=module["module_summary"]
                )
                modules_with_ids.append(module_with_id)
            
            # Create course response
            course_response = CourseResponse(
                course_title=course_json["course_title"],
                course_description=course_json["course_description"],
                course_introduction=course_json["course_introduction"],
                modules=modules_with_ids
            )
            
            return course_response
        except Exception as e:
            raise HTTPException(
                status_code=500, detail=f"Error generating course from document: {str(e)}"
            )
    
    async def generate_module_from_document(
        self, document: DocumentContent, course_info: Dict[str, Any], module_id: str, 
        additional_context: Optional[str] = None
    ) -> ModuleResponse:
        """
        Generate detailed module content from a document.
        
        Args:
            document: The processed document content
            course_info: Information about the parent course
            module_id: The ID of the module to generate
            additional_context: Optional additional context or instructions
            
        Returns:
            A detailed module structure including lessons
        """
        # Find the module info from the course
        module_info = None
        for module in course_info.get("modules", []):
            if module.get("module_id") == module_id:
                module_info = module
                break
        
        if not module_info:
            raise HTTPException(status_code=404, detail=f"Module with ID {module_id} not found")
        
        # Extract relevant content for this module based on module title
        module_title = module_info.get("module_title", "")
        module_relevant_content = self._extract_relevant_content(document, module_title)
        
        additional_instructions = additional_context if additional_context else ""
        
        # Create prompt for module generation
        prompt = f"""
        Generate a detailed module for a course based on the following document content.
        
        COURSE TITLE: {course_info.get("course_title", "")}
        MODULE TITLE: {module_title}
        MODULE SUMMARY: {module_info.get("module_summary", "")}
        
        RELEVANT DOCUMENT CONTENT:
        {module_relevant_content}
        
        {additional_instructions}
        
        Create a detailed module with:
        1. A refined module title (if needed)
        2. Comprehensive module description (2-3 paragraphs)
        3. Clear learning objectives (3-6 items)
        4. Estimated completion time
        5. 3-7 lessons that cover the module content
        
        For each lesson provide:
        - A descriptive title
        - A brief summary (1-2 sentences)
        
        Format the response as a JSON object with the following structure:
        {{
          "module_title": "...",
          "module_description": "...",
          "learning_objectives": ["...", "..."],
          "estimated_time": "...",
          "lessons": [
            {{
              "lesson_title": "...",
              "lesson_summary": "..."
            }}
          ]
        }}
        """
        
        try:
            # Generate module structure using AI
            module_json = await self.ai_service.generate_structured_content(prompt)
            
            # Add lesson_id to each lesson
            from app.utils.id_generator import generate_id
            
            lessons_with_ids = []
            for lesson in module_json["lessons"]:
                lesson_with_id = LessonInfo(
                    lesson_id=generate_id("les"),
                    lesson_title=lesson["lesson_title"],
                    lesson_summary=lesson["lesson_summary"]
                )
                lessons_with_ids.append(lesson_with_id)
            
            # Create module response
            module_response = ModuleResponse(
                module_id=module_id,
                module_title=module_json["module_title"],
                module_description=module_json["module_description"],
                learning_objectives=module_json["learning_objectives"],
                estimated_time=module_json["estimated_time"],
                lessons=lessons_with_ids
            )
            
            return module_response
        except Exception as e:
            raise HTTPException(
                status_code=500, detail=f"Error generating module from document: {str(e)}"
            )
    
    async def generate_lesson_from_document(
        self, document: DocumentContent, module_info: Dict[str, Any], lesson_id: str,
        additional_context: Optional[str] = None
    ) -> LessonResponse:
        """
        Generate detailed lesson content from a document.
        
        Args:
            document: The processed document content
            module_info: Information about the parent module
            lesson_id: The ID of the lesson to generate
            additional_context: Optional additional context or instructions
            
        Returns:
            A detailed lesson structure including content and quiz
        """
        # Find the lesson info from the module
        lesson_info = None
        for lesson in module_info.get("lessons", []):
            if lesson.get("lesson_id") == lesson_id:
                lesson_info = lesson
                break
        
        if not lesson_info:
            raise HTTPException(status_code=404, detail=f"Lesson with ID {lesson_id} not found")
        
        # Extract relevant content for this lesson based on lesson title and module title
        lesson_title = lesson_info.get("lesson_title", "")
        module_title = module_info.get("module_title", "")
        
        lesson_relevant_content = self._extract_relevant_content(
            document, f"{module_title} {lesson_title}"
        )
        
        additional_instructions = additional_context if additional_context else ""
        
        # Create prompt for lesson generation
        prompt = f"""
        Generate a comprehensive lesson for a course module based on the following document content.
        
        MODULE TITLE: {module_title}
        LESSON TITLE: {lesson_title}
        LESSON SUMMARY: {lesson_info.get("lesson_summary", "")}
        
        RELEVANT DOCUMENT CONTENT:
        {lesson_relevant_content}
        
        {additional_instructions}
        
        Create a detailed lesson with:
        1. A refined lesson title (if needed)
        2. Specific learning objectives for this lesson (2-4 items)
        3. Comprehensive lesson content with:
           - Introduction
           - Main content sections (well-structured with headings)
           - Examples or case studies
           - Summary or key takeaways
        4. 3-5 quiz questions to test understanding
        
        For each quiz question provide:
        - The question text
        - 4 options (for multiple choice)
        - The correct answer
        - An explanation of why that answer is correct
        
        Format the response as a JSON object with the following structure:
        {{
          "lesson_title": "...",
          "learning_objectives": ["...", "..."],
          "content": {{"introduction": "...", "main_content": "...", "examples": "...", "summary": "..."}},
          "quiz": [
            {{
              "question": "...",
              "options": ["...", "...", "...", "..."],
              "correct_answer": "...",
              "explanation": "..."
            }}
          ]
        }}
        """
        
        try:
            # Generate lesson structure using AI
            lesson_json = await self.ai_service.generate_structured_content(prompt)
            
            # Convert quiz questions to the expected format
            quiz_questions = []
            for quiz_item in lesson_json.get("quiz", []):
                quiz_question = QuizQuestion(
                    question=quiz_item["question"],
                    options=quiz_item["options"],
                    correct_answer=quiz_item["correct_answer"],
                    explanation=quiz_item["explanation"]
                )
                quiz_questions.append(quiz_question)
            
            # Create lesson response
            content = lesson_json.get("content", {})
            
            # Ensure content values are strings
            processed_content = {}
            for key, value in content.items():
                if isinstance(value, dict):
                    # Convert dictionaries to formatted strings
                    processed_content[key] = json.dumps(value, indent=2)
                else:
                    processed_content[key] = str(value)
            
            # Combine all content parts into a single text for legacy compatibility
            full_content_text = f"""
Introduction:
{processed_content.get("introduction", "")}

Main Content:
{processed_content.get("main_content", "")}

Examples:
{processed_content.get("examples", "")}

Summary:
{processed_content.get("summary", "")}
"""
            lesson_response = LessonResponse(
                lesson_id=lesson_id,
                lesson_title=lesson_json["lesson_title"],
                learning_objectives=lesson_json["learning_objectives"],
                content={
                    "introduction": processed_content.get("introduction", ""),
                    "main_content": processed_content.get("main_content", ""),
                    "examples": processed_content.get("examples", ""),
                    "summary": processed_content.get("summary", "")
                },
                quiz=quiz_questions,
                lesson_content=full_content_text.strip()  # Add this for backward compatibility
            )
            
            return lesson_response
        except Exception as e:
            raise HTTPException(
                status_code=500, detail=f"Error generating lesson from document: {str(e)}"
            )
    
    async def generate_quiz_from_document(
        self, document: DocumentContent, lesson_info: Dict[str, Any],
        additional_context: Optional[str] = None, question_count: int = 10
    ) -> List[QuizQuestion]:
        """
        Generate a comprehensive quiz based on lesson content and document.
        
        Args:
            document: The processed document content
            lesson_info: Information about the lesson
            additional_context: Optional additional context or instructions
            question_count: Number of questions to generate
            
        Returns:
            A list of quiz questions
        """
        lesson_title = lesson_info.get("lesson_title", "")
        lesson_content = ""
        
        if "content" in lesson_info:
            content = lesson_info["content"]
            lesson_parts = [
                content.get("introduction", ""),
                content.get("main_content", ""),
                content.get("examples", ""),
                content.get("summary", "")
            ]
            lesson_content = "\n\n".join([part for part in lesson_parts if part])
        
        # Extract relevant content for this quiz
        relevant_content = self._extract_relevant_content(document, lesson_title)
        
        additional_instructions = additional_context if additional_context else ""
        
        # Create prompt for quiz generation
        prompt = f"""
        Generate a comprehensive quiz based on the following lesson content.
        
        LESSON TITLE: {lesson_title}
        LESSON CONTENT: 
        {lesson_content}
        
        RELEVANT DOCUMENT CONTENT:
        {relevant_content}
        
        {additional_instructions}
        
        Create {question_count} quiz questions that:
        - Cover the key concepts from the lesson
        - Vary in difficulty (easy, medium, hard)
        - Include a mix of question types (multiple choice, true/false)
        - Test both factual recall and conceptual understanding
        
        For each question provide:
        - Clear question text
        - For multiple choice: 4 plausible options with only 1 correct answer
        - For true/false: The statement to evaluate
        - The correct answer
        - A brief explanation of why the answer is correct
        
        Format the response as a JSON array of questions:
        [
          {{
            "question": "...",
            "options": ["...", "...", "...", "..."],
            "correct_answer": "...",
            "explanation": "..."
          }},
          ...
        ]
        """
        
        try:
            # Generate quiz questions using AI
            quiz_json = await self.ai_service.generate_structured_content(prompt)
            
            # Convert to expected format
            quiz_questions = []
            for quiz_item in quiz_json:
                quiz_question = QuizQuestion(
                    question=quiz_item["question"],
                    options=quiz_item["options"],
                    correct_answer=quiz_item["correct_answer"],
                    explanation=quiz_item["explanation"]
                )
                quiz_questions.append(quiz_question)
            
            return quiz_questions
        except Exception as e:
            raise HTTPException(
                status_code=500, detail=f"Error generating quiz from document: {str(e)}"
            )
    
    def _extract_relevant_content(self, document: DocumentContent, topic: str) -> str:
        """
        Extract content relevant to a specific topic from the document.
        
        This is a basic implementation that could be enhanced with more sophisticated
        semantic search or text chunking/embedding techniques.
        
        Args:
            document: The processed document
            topic: The topic to find relevant content for
            
        Returns:
            String containing the most relevant content
        """
        # Simple approach: split document by paragraphs and find those containing keywords
        content = document.content
        paragraphs = content.split('\n\n')
        
        # Extract keywords from topic
        keywords = topic.lower().split()
        
        # Score paragraphs based on keyword matches
        relevant_paragraphs = []
        for paragraph in paragraphs:
            paragraph_lower = paragraph.lower()
            score = sum(1 for keyword in keywords if keyword in paragraph_lower)
            if score > 0:
                relevant_paragraphs.append((paragraph, score))
        
        # Sort by relevance score
        relevant_paragraphs.sort(key=lambda x: x[1], reverse=True)
        
        # Get top paragraphs (up to 5000 characters)
        result = ""
        char_count = 0
        for paragraph, _ in relevant_paragraphs:
            if char_count + len(paragraph) > 5000:
                break
            result += paragraph + "\n\n"
            char_count += len(paragraph) + 2
        
        # If we have too little content, add some general content from the beginning of the document
        if char_count < 1000:
            general_content = content[:5000 - char_count]
            result += "\n\nAdditional document content:\n\n" + general_content
        
        return result
