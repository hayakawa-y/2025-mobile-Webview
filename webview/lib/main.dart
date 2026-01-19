import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 222, 108, 215))),
      home: const MyHomePage(title: 'Webview JS Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
late final WebViewController _controller;
String totalFromJS = "";

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('FlutterChannel',onMessageReceived: (JavaScriptMessage message){
        setState(() {
          totalFromJS = message.message;
        });
      },)
      ..loadHtmlString(htmlContent);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: Column(
        children: [
          Expanded(child: WebViewWidget(controller:   _controller)),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[200],
            width: double.infinity,
            child: Text("Receive from JS $totalFromJS",style: const TextStyle(fontSize: 18)),
            
          )

        ],
      )),
    );
  }
}

const String htmlContent = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
</head>
<body>
    <h1>My Cart
    <p id="total">Total: \$120</p></h1>
    <button style="
            padding: 16px 32px;
            font-size: 20px;
            width: 100%;
            border-radius: 14px;
            border: 2px solid #ddd;
            background-color: #f7f7f7;
            color: #1e88e5;
            cursor: pointer;"
        onclick = "sendTotalToFlutter()">Send Total to Flutter</button>
    
        <script>
            function sendTotalToFlutter(){
                var totalPrice = document.getElementById('total').innerText;
                FlutterChannel.postMessage(totalPrice);
            }
        </script>
</body>
</html>""";
