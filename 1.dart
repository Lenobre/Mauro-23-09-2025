import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz de Conhecimentos Gerais',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int questionIndex = 0;
  int score = 0;

  final List<Map<String, Object>> questions = [
    {
      'question': 'Qual é a capital da França?',
      'answers': ['Berlim', 'Madrid', 'Paris', 'Roma'],
      'correctAnswer': 2,
    },
    {
      'question': 'Quem escreveu "Dom Quixote"?',
      'answers': ['William Shakespeare', 'Miguel de Cervantes', 'Gabriel García Márquez', 'Fiódor Dostoiévski'],
      'correctAnswer': 1,
    },
    {
      'question': 'Qual é o maior planeta do sistema solar?',
      'answers': ['Terra', 'Marte', 'Júpiter', 'Saturno'],
      'correctAnswer': 2,
    },
    {
      'question': 'Em que ano ocorreu a Revolução Francesa?',
      'answers': ['1776', '1789', '1812', '1848'],
      'correctAnswer': 1,
    },
    {
      'question': 'Quem pintou a Mona Lisa?',
      'answers': ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Claude Monet'],
      'correctAnswer': 2,
    },
    {
      'question': 'Qual é o elemento químico representado pelo símbolo "O"?',
      'answers': ['Ouro', 'Oxigênio', 'Osmium', 'Ósmio'],
      'correctAnswer': 1,
    },
    {
      'question': 'Qual é o rio mais longo do mundo?',
      'answers': ['Rio Amazonas', 'Rio Nilo', 'Rio Yangtzé', 'Rio Mississippi'],
      'correctAnswer': 1,
    },
    {
      'question': 'Quem foi o primeiro presidente dos Estados Unidos?',
      'answers': ['Abraham Lincoln', 'Thomas Jefferson', 'George Washington', 'John Adams'],
      'correctAnswer': 2,
    },
    {
      'question': 'Qual é o país mais populoso do mundo?',
      'answers': ['Índia', 'Estados Unidos', 'China', 'Indonésia'],
      'correctAnswer': 2,
    },
    {
      'question': 'Qual é a fórmula química da água?',
      'answers': ['CO2', 'H2O', 'O2', 'NaCl'],
      'correctAnswer': 1,
    },
  ];

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[questionIndex]['correctAnswer']) {
      score++;
    }
    setState(() {
      if (questionIndex < questions.length - 1) {
        questionIndex++;
      } else {
        _showScore();
      }
    });
  }

  void _showScore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seu Resultado'),
        content: Text('Você acertou $score de ${questions.length} perguntas!'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                score = 0;
                questionIndex = 0;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz de Conhecimentos Gerais'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questions[questionIndex]['question'] as String,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...(questions[questionIndex]['answers'] as List<String>).map((answer) {
              int index = (questions[questionIndex]['answers'] as List<String>).indexOf(answer);
              return ElevatedButton(
                onPressed: () => answerQuestion(index),
                child: Text(answer),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
