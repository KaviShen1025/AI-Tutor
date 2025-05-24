# TuteAI - AI-Powered Course Generation System

TuteAI is an intelligent course generation platform that leverages Google's Gemini AI to create structured educational content. The system enables educators, trainers, and content creators to quickly build complete courses with detailed modules, lessons, and assessments.

## 🌟 Features

- **Complete Course Planning**: Generate course outlines with customized titles, descriptions, and modules
- **Module Development**: Create detailed module plans with logical lesson sequencing
- **Lesson Content Generation**: Develop comprehensive lesson content aligned with learning objectives
- **Quiz Generation**: Automatically create assessment questions with explanations
- **API-First Architecture**: Access all functionality through a well-documented RESTful API
- **Versioned API Design**: Built for long-term extensibility and backward compatibility

## 🛠️ Technical Architecture

TuteAI follows a clean, modular architecture designed for maintainability and scalability:

### Directory Structure

```
tuteAI/
├── app/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── endpoints/
│   │   │   │   ├── courses.py
│   │   │   │   ├── lessons.py
│   │   │   │   ├── modules.py
│   │   │   │   └── __init__.py
│   │   │   ├── router.py
│   │   │   └── __init__.py
│   │   └── __init__.py
│   ├── models/
│   │   ├── course.py
│   │   ├── lesson.py
│   │   ├── module.py
│   │   └── __init__.py
│   ├── services/
│   │   ├── ai_service.py
│   │   └── __init__.py
│   ├── utils/
│   │   ├── id_generator.py
│   │   └── __init__.py
│   ├── config.py
│   └── __init__.py
├── main.py
├── requirements.txt
├── .env
└── README.md
```

### Key Components

1. **API Layer** (`app/api/`):
   - Versioned endpoints (v1, with architecture supporting future versions)
   - Clean separation of resource-specific routes (courses, modules, lessons)
   - Consistent error handling and response formatting

2. **Models** (`app/models/`):
   - Pydantic data models for request validation and response serialization
   - Separated by domain concern (course, module, lesson)

3. **Services** (`app/services/`):
   - AI service layer abstracting communication with Gemini AI
   - Handles prompt engineering and response processing

4. **Utils** (`app/utils/`):
   - Helper functions like ID generation

5. **Configuration** (`app/config.py`):
   - Environment-based settings management with pydantic-settings
   - Secret handling with dotenv

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- Google AI API key for Gemini model access

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/tuteAI.git
   cd tuteAI
   ```

2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Create a `.env` file in the project root:
   ```
   GOOGLE_API_KEY=your-api-key-here
   ```

5. Run the application:
   ```bash
   python main.py
   ```

The API will be available at http://localhost:8000

## 📚 API Documentation

Once the server is running, you can access the interactive API documentation at:
- **ReDoc**: http://localhost:8000/redoc
  - Clean, responsive, and searchable documentation
  - Three-panel layout for better navigation
  - Detailed schema information and endpoint descriptions
  - More readable for complex APIs with deep object hierarchies

- **Swagger UI**: http://localhost:8000/docs
  - Interactive documentation with a user-friendly interface
  - Test API endpoints directly from the browser
  - Visualize request/response structures and data models
  - Explore available parameters and authentication requirements

Both interfaces provide comprehensive documentation of all available endpoints, request parameters, response formats, and data models. They are automatically generated from the OpenAPI specification and stay in sync with your API's implementation.

### Core Endpoints

#### Course Planning
```
POST http://localhost:8000/api/v1/plan-course
```
Create a structured course outline with modules.

Example:
```bash
curl -X POST \
  http://localhost:8000/api/v1/plan-course \
  -H "Content-Type: application/json" \
  -d '{
    "course_title": "Introduction to Machine Learning",
    "course_description": "A comprehensive course covering ML fundamentals",
    "target_audience": "Undergraduate CS students",
    "time_available": "6 weeks, 2 hours per week",
    "learning_objectives": [
      "Understand basic ML concepts",
      "Implement simple algorithms",
      "Evaluate model performance"
    ],
    "preferred_format": "balanced"
  }'
```

#### Module Planning
```
POST http://localhost:8000/api/v1/plan-module
```
Generate detailed module structure with lessons.

Example:
```bash
curl -X POST \
  http://localhost:8000/api/v1/plan-module \
  -H "Content-Type: application/json" \
  -d '{
    "course_title": "Introduction to Machine Learning",
    "course_description": "A comprehensive course covering ML fundamentals",
    "module_title": "Supervised Learning",
    "module_summary": "Understanding classification and regression algorithms"
  }'
```

#### Lesson Content
```
POST http://localhost:8000/api/v1/create-lesson-content
```
Create comprehensive lesson content.

Example:
```bash
curl -X POST \
  http://localhost:8000/api/v1/create-lesson-content \
  -H "Content-Type: application/json" \
  -d '{
    "course_title": "Introduction to Machine Learning",
    "module_title": "Supervised Learning",
    "lesson_title": "Linear Regression",
    "lesson_objective": "Understand and implement simple linear regression models"
  }'
```

#### Quiz Generation
```
POST http://localhost:8000/api/v1/create-quiz
```
Generate assessment questions for a lesson.

Example:
```bash
curl -X POST \
  http://localhost:8000/api/v1/create-quiz \
  -H "Content-Type: application/json" \
  -d '{
    "course_title": "Introduction to Machine Learning",
    "module_title": "Supervised Learning",
    "lesson_title": "Linear Regression",
    "lesson_objective": "Understand and implement simple linear regression models",
    "num_questions": 5
  }'
```

> **with documents;**

#### Document Upload
```
POST http://localhost:8000/api/v1/documents/upload
```
Upload a document (PDF, DOCX, or PPTX) to generate a course.
```bash
curl -X POST -F "file=@your_document.pdf" http://localhost:8000/api/v1/documents/upload
```

#### Get Document
```
GET http://localhost:8000/api/v1/documents/{documentId}
```
Get document details by ID.
```bash
curl http://localhost:8000/api/v1/documents/your_document_id
```

#### Course Planning (v1)
```
POST http://localhost:8000/api/v1/document-courses/generate-course
```
Generate a complete course structure based on an uploaded document.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "document_id": "your_document_id"
   }' \
   http://localhost:8000/api/v1/document-courses/generate-course
```

#### Module Planning (v1)
```
POST http://localhost:8000/api/v1/document-courses/generate-module
```
Generate detailed module structure with lessons for a specific course.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "document_id": "your_document_id",
      "course_info": {
         "course_title": "Your Course Title"
      },
      "module_id": "your_module_id"
   }' \
   http://localhost:8000/api/v1/document-courses/generate-module
```

#### Lesson Content (v1)
```
POST http://localhost:8000/api/v1/document-courses/generate-lesson
```
Create comprehensive lesson content for a specific module.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "document_id": "your_document_id",
      "module_info": {
         "module_id": "your_module_id",
         "module_title": "Your Module Title",
         "lessons": []
      },
      "lesson_id": "your_lesson_id"
   }' \
   http://localhost:8000/api/v1/document-courses/generate-lesson
```

#### Quiz Generation (v1)
```
POST http://localhost:8000/api/v1/document-courses/generate-quiz
```
Generate assessment questions for a lesson.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "document_id": "your_document_id",
      "lesson_info": {
         "lesson_id": "your_lesson_id"
      },
      "question_count": 5
   }' \
   http://localhost:8000/api/v1/document-courses/generate-quiz
```

#### API Health Check (v2)
```
GET http://localhost:8000/api/v2/health
```
Check the health status of the API.
```bash
curl http://localhost:8000/api/v2/health
```

#### Course Planning (v2)
```
POST http://localhost:8000/api/v2/courses
```
Generate a course plan using the v2 API.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "course_title": "Your Course Title",
      "course_description": "Your Course Description",
      "target_audience": "Your Target Audience",
      "time_available": "Your Time Available",
      "learning_objectives": ["Objective 1", "Objective 2"],
      "preferred_format": "balanced",
      "content_style": "conversational"
   }' \
   http://localhost:8000/api/v2/courses
```

#### Module Planning (v2)
```
POST http://localhost:8000/api/v2/modules
```
Generate a module plan using the v2 API.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "course_id": "your_course_id",
      "module_title": "Your Module Title",
      "module_summary": "Your Module Summary",
      "key_concepts": ["Concept 1", "Concept 2"]
   }' \
   http://localhost:8000/api/v2/modules
```

#### Lesson Content (v2)
```
POST http://localhost:8000/api/v2/lessons
```
Generate lesson content using the v2 API.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "module_id": "your_module_id",
      "lesson_title": "Your Lesson Title",
      "lesson_objective": "Your Lesson Objective",
      "focus_areas": ["Area 1", "Area 2"]
   }' \
   http://localhost:8000/api/v2/lessons
```

#### Quiz Generation (v2)
```
POST http://localhost:8000/api/v2/quizzes
```
Generate a quiz using the v2 API.
```bash
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{
      "lesson_id": "your_lesson_id",
      "num_questions": 5,
      "quiz_difficulty": "intermediate",
      "include_explanations": true
   }' \
   http://localhost:8000/api/v2/quizzes
```

## 🧠 AI Integration

TuteAI utilizes Google's Gemini 2.0 Flash model for content generation. The AI service component:

1. Formats specialized prompts based on user inputs
2. Processes responses to extract structured data
3. Handles JSON parsing and validation
4. Manages error scenarios gracefully

## 🛡️ Environment Configuration

The application uses environment variables for configuration:
- `GOOGLE_API_KEY`: Your Google AI API key
- Additional configuration parameters can be added to the `Settings` class in `config.py`

## 🌱 Future Development

TuteAI's architecture is designed for extensibility:

1. **API Versioning**: The `/api/v1` prefix allows for future API versions without breaking changes
2. **Additional AI Models**: The service layer can be extended to support multiple AI providers
3. **Content Storage**: Integration with a database for persistence
4. **User Authentication**: Role-based access control for content creators
5. **Export Formats**: Support for exporting courses to various LMS formats

## 📄 License

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/) - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
