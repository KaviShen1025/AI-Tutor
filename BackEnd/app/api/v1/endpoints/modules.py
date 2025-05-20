from fastapi import APIRouter, HTTPException, Depends
from app.models.module import ModuleRequest, ModuleResponse, LessonInfo
from app.services.ai_service import AIService
from app.utils.id_generator import generate_id

router = APIRouter(tags=["modules"])
ai_service = AIService()

@router.post("/plan-module", response_model=ModuleResponse)
async def plan_module(request: ModuleRequest):
    # Prepare the prompt for module planning
    prompt = f"""
    Create a detailed module plan based on the following information and search from web (findIt_google) and web Scrap (findIt_scrap) for additional resources:
    
    COURSE TITLE: {request.course_title}
    COURSE DESCRIPTION: {request.course_description}
    
    MODULE TITLE: {request.module_title}
    MODULE SUMMARY: {request.module_summary}
    
    Generate:
    1. A compelling module introduction (1 paragraph) that connects to the overall course objectives
    2. 3-5 logical lessons that cover the module content comprehensively and align with the course goals
    
    For each lesson provide:
    - A clear title
    - A brief summary (1-2 sentences) that describes what the lesson covers
    
    Format the response as a JSON object with the following structure:
    {{
      "module_introduction": "...",
      "lessons": [
        {{
          "lesson_title": "...",
          "lesson_summary": "..."
        }}
      ]
    }}
    """
    
    try:
        module_json = await ai_service.generate_structured_content(prompt)
        
        # Add lesson_id to each lesson
        lessons_with_ids = []
        for lesson in module_json["lessons"]:
            lesson_with_id = LessonInfo(
                lesson_id=generate_id("les"),
                lesson_title=lesson["lesson_title"],
                lesson_summary=lesson.get("lesson_summary", "")  # Use the field as named in the prompt
            )
            lessons_with_ids.append(lesson_with_id)
        
        module_response = ModuleResponse(
            module_id=generate_id("mod"),  # Generate a new module ID
            module_title=request.module_title,
            module_description=request.module_summary,
            learning_objectives=["Understand and apply concepts covered in this module"],  # Default objective
            estimated_time="2-3 hours",  # Default time estimate
            module_introduction=module_json["module_introduction"],
            lessons=lessons_with_ids
        )
        
        return module_response
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating module: {str(e)}")
