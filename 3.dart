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

  // Carregar o progresso salvo
  void loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentTabuada = prefs.getInt('currentTabuada') ?? 1; // Pega a tabuada salva ou começa com 1
      currentMultiplicando = prefs.getInt('currentMultiplicando') ?? 1; // Pega o multiplicando salvo ou começa com 1
      correctAnswers = prefs.getInt('correctAnswers') ?? 0; // Pega os acertos salvos ou começa com 0
    });
  }

  // Salvar o progresso
  void saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentTabuada', currentTabuada);
    prefs.setInt('currentMultiplicando', currentMultiplicando);
    prefs.setInt('correctAnswers', correctAnswers);
  }

  // Checar se a resposta está correta
  void checkAnswer() {
    int correctResult = currentTabuada * currentMultiplicando;
    
    // Verificando a resposta do usuário
    String answerText = answerController.text.trim();
    
    if (answerText.isEmpty) {
      // Se o campo estiver vazio, mostramos um alerta
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, insira uma resposta.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    // Tentando converter a resposta para número
    int userAnswer;
    try {
      userAnswer = int.parse(answerText);
    } catch (e) {
      // Se não for um número válido, mostramos um erro
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Resposta inválida. Digite apenas números.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    // Imprimir para debug
    print('Resposta correta: $correctResult');
    print('Resposta do usuário: $userAnswer');

    // Comparando a resposta do usuário com a resposta correta
    if (userAnswer == correctResult) {
      correctAnswers++;
      // Avança para o próximo número da tabuada
      if (currentMultiplicando < 10) {
        setState(() {
          currentMultiplicando++;  // Atualiza a multiplicação
        });
      } else {
        // Avança para a próxima tabuada
        if (currentTabuada < 10) {
          setState(() {
            currentTabuada++;       // Atualiza a tabuada
            currentMultiplicando = 1;  // Reseta o multiplicando
          });
        }
      }
      // Salvar progresso após a resposta correta
      saveProgress();
    } else {
      // Se errar, não avança na tabuada
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Resposta errada, tente novamente!'),
        duration: Duration(seconds: 2),
      ));
    }

    // Limpa o campo de resposta
    answerController.clear();
  }

  @override
  void initState() {
    super.initState();
    loadProgress(); // Carregar o progresso ao iniciar
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
