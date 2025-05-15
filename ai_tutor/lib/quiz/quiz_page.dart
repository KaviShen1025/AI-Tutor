import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final String section;

  const QuizPage({
    super.key,
    required this.section,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  Map<int, int> _selectedAnswers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is ethical hacking primarily focused on?',
      'options': [
        'Breaking into systems illegally',
        'Identifying security vulnerabilities',
        'Writing malicious code',
        'Stealing data'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Which framework is commonly used in ethical hacking?',
      'options': ['OWASP', 'React', 'Angular', 'Vue'],
      'correctAnswer': 0,
    },
    {
      'question': 'What is the first step in ethical hacking methodology?',
      'options': [
        'Gaining Access',
        'Scanning',
        'Planning and Reconnaissance',
        'Reporting'
      ],
      'correctAnswer': 2,
    },
  ];

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitQuiz() {
    int correctAnswers = 0;
    _selectedAnswers.forEach((questionIndex, selectedAnswer) {
      if (selectedAnswer == _questions[questionIndex]['correctAnswer']) {
        correctAnswers++;
      }
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          section: widget.section,
          score: correctAnswers,
          totalQuestions: _questions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        primaryColor: Colors.blue.shade400,
        secondaryColor: Colors.blue.shade600,
        opacity: 0.03,
        enableWaves: true,
        enableParticles: true,
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quiz: ${widget.section}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress indicator
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor:
                              (_currentQuestionIndex + 1) / _questions.length,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Question number
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Question
                      Text(
                        question['question'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Options
                      ...List.generate(
                        question['options'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => _selectAnswer(index),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    _selectedAnswers[_currentQuestionIndex] ==
                                            index
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      _selectedAnswers[_currentQuestionIndex] ==
                                              index
                                          ? Colors.blue
                                          : Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _selectedAnswers[
                                                    _currentQuestionIndex] ==
                                                index
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      color: _selectedAnswers[
                                                  _currentQuestionIndex] ==
                                              index
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                    child: _selectedAnswers[
                                                _currentQuestionIndex] ==
                                            index
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      question['options'][index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Navigation buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentQuestionIndex > 0)
                            SizedBox(
                              width: 130,
                              child: ElevatedButton(
                                onPressed: _previousQuestion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  foregroundColor: Colors.grey[800],
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back, size: 20),
                                    SizedBox(width: 8),
                                    Text('Previous'),
                                  ],
                                ),
                              ),
                            ),
                          if (_currentQuestionIndex > 0)
                            const SizedBox(width: 12),
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              onPressed:
                                  _currentQuestionIndex == _questions.length - 1
                                      ? _submitQuiz
                                      : _nextQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentQuestionIndex ==
                                            _questions.length - 1
                                        ? 'Submit'
                                        : 'Next',
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    _currentQuestionIndex ==
                                            _questions.length - 1
                                        ? Icons.check
                                        : Icons.arrow_forward,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
