import 'package:flutter/material.dart';
import 'package:ai_tutor/models/quiz_models.dart';

class QuizPage extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String lessonTitle;

  const QuizPage({
    super.key,
    required this.questions,
    required this.lessonTitle,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _answerSubmitted = false;
  int _score = 0;

  void _submitAnswer() {
    setState(() {
      _answerSubmitted = true;
      if (_selectedAnswer == widget.questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answerSubmitted = false;
      });
    } else {
      // End of quiz - show results
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Quiz Results'),
            content: Text('You scored $_score out of ${widget.questions.length}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back from QuizPage
                },
              ),
            ],
          );
        },
      );
    }
  }

  Color _getOptionColor(String option) {
    if (!_answerSubmitted) {
      return Colors.grey.shade200; // Default color
    }
    if (option == widget.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.green.shade100; // Correct answer color
    }
    if (option == _selectedAnswer && option != widget.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.red.shade100; // Incorrect selected answer color
    }
    return Colors.grey.shade200; // Default for non-selected, non-correct options
  }

  IconData? _getOptionIcon(String option) {
    if (!_answerSubmitted) {
      return null;
    }
    if (option == widget.questions[_currentQuestionIndex].correctAnswer) {
      return Icons.check_circle;
    }
    if (option == _selectedAnswer && option != widget.questions[_currentQuestionIndex].correctAnswer) {
      return Icons.cancel;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz: ${widget.lessonTitle}'),
          backgroundColor: Colors.blue.shade700,
        ),
        body: const Center(child: Text('No questions available for this quiz.')),
      );
    }
    
    final currentQuestion = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.lessonTitle} (${_currentQuestionIndex + 1}/${widget.questions.length})'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              currentQuestion.question,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Options:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Column(
              children: currentQuestion.options.map((option) {
                return Card(
                  elevation: _answerSubmitted ? 0 : 2,
                  color: _getOptionColor(option),
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _selectedAnswer,
                    onChanged: _answerSubmitted ? null : (value) {
                      setState(() {
                        _selectedAnswer = value;
                      });
                    },
                    secondary: _getOptionIcon(option) != null 
                               ? Icon(_getOptionIcon(option), color: option == currentQuestion.correctAnswer ? Colors.green : Colors.red) 
                               : null,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24.0),
            if (_answerSubmitted) ...[
              Text(
                'Explanation:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  currentQuestion.explanation,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 24.0),
            ],
            Center( // Center the button
              child: ElevatedButton(
                onPressed: _selectedAnswer == null && !_answerSubmitted ? null : (_answerSubmitted ? _nextQuestion : _submitAnswer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(_answerSubmitted ? 'Next Question' : 'Submit Answer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
