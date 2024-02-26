import 'package:flutter/material.dart';
import 'package:carbonet/widgets/widget_card.dart';

void main() {
  runApp(const CarboNet());
}

class CarboNet extends StatelessWidget {
  const CarboNet({super.key});

  // Esse widget é a raiz da aplicação.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarboNet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6FF4)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Esse widget é a página home da aplicação. Ela é do tipo stateful, que
  // significa que ela tem um objeto State (definido abaixo) que contem campos
  // que afetam a maneira como o aplicativo se parece.

  // Essa classe é a configuração para o state. Ela guarda os valores (nesse
  // caso por titulo) disponibilizados pelo widget pai (nesse casso o widget
  // 'App') e usados pelo método 'build' do State. Campos em uma subclasse
  // Widget são sempre marcados como "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // Esse método é re-executado toda vez que a função setState é chamada.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B6FF4),
        leading: IconButton(
          // icon: Icon(Icons.headphones),
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.network("https://t2.tudocdn.net/125246?w=1920"),
          ),
          onPressed: () => print("hey"),
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: const Center(
        // "Center" é um widget de layout. Ele recebe um único filho e posiciona
        // no meio de seu widget pai.
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            // "Column" também é um widget de layout. Ele pega uma lista de
            // widgets filhos e posiciona eles verticalmente. Por padrão, ele muda
            // seu tamanho para o tamanho de seus filhos horizontalmente, e tenta
            // atingir a mesma altura que seu widget pai
          
            // "Column" tem várias propriedades que controlam seu tamanho e
            // como ele posiciona seus filhos. Aqui nós usamos a propriedade
            // mainAxisAlignment para centralizar as crianças verticalmente; o
            // eixo principal aqui é o vertical pois widgets do tipo "Column"
            // são verticais. 
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: <Widget>[
              CardButton(),
            ],
          ),
        ),
      ),
    );
  }
}
