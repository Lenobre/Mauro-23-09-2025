import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treinamento de Tabuada',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabuadaPage(),
    );
  }
}

class TabuadaPage extends StatefulWidget {
  @override
  _TabuadaPageState createState() => _TabuadaPageState();
}

class _TabuadaPageState extends State<TabuadaPage> {
  int currentTabuada = 1;
  int currentMultiplicando = 1;
  TextEditingController answerController = TextEditingController();
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  // Carregar o estado salvo
  Future<void> _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentTabuada = prefs.getInt('currentTabuada') ?? 1;
      correctAnswers = prefs.getInt('correctAnswers') ?? 0;
      currentMultiplicando = prefs.getInt('currentMultiplicando') ?? 1;
    });
  }

  // Salvar o estado atual
  Future<void> _saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentTabuada', currentTabuada);
    await prefs.setInt('correctAnswers', correctAnswers);
    await prefs.setInt('currentMultiplicando', currentMultiplicando);
  }

  // Checar se a resposta está correta
  void checkAnswer() {
    int correctResult = currentTabuada * currentMultiplicando;
    int userAnswer = int.tryParse(answerController.text) ?? -1;

    if (userAnswer == correctResult) {
      correctAnswers++;
      // Avança para o próximo número da tabuada
      if (currentMultiplicando < 10) {
        currentMultiplicando++;
      } else {
        // Avança para a próxima tabuada
        if (currentTabuada < 10) {
          currentTabuada++;
          currentMultiplicando = 1;
        }
      }
    } else {
      // Se errar, não avança na tabuada
      // Exibimos um feedback
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Resposta errada, tente novamente!'),
        duration: Duration(seconds: 1),
      ));
    }

    // Salva o estado após a tentativa
    _saveState();
    answerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinamento de Tabuada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tabuada: $currentTabuada',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Qual é o resultado de $currentTabuada x $currentMultiplicando?',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sua resposta',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              child: Text('Enviar'),
            ),
            SizedBox(height: 20),
            Text(
              'Acertos: $correctAnswers',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
