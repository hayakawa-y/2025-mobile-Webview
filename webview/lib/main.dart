import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController _controller;
  int totalFromJS = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // Challenge 2
          setState(() {
            totalFromJS = int.parse(message.message);
          });
        },
      )
      ..loadRequest(
        Uri.dataFromString(
          htmlContent,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
  }

  // Challenge 3
  void _sendBackToJS() {
    final newTotal = totalFromJS + 100;
    _controller.runJavaScript(
      "updateTotalFromFlutter($newTotal);",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Webview JS Example")),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Challenge 2
                Text(
                  "Retrieve from JS",
                  style: const TextStyle(fontSize: 18),
                ),
                
                const SizedBox(height: 10),

                // Challenge 3
                ElevatedButton(
                  onPressed: _sendBackToJS,
                  child: const Text("send +100 Total From Flutter to JS"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



const String htmlContent = """
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Cart</title>

  <style>
    .item {
      border: 1px solid #ccc;
      border-radius: 8px;
      padding: 10px;
      margin-bottom: 10px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 14px;
    }

    .item span {
      margin: 0 5px;
    }

    .item button {
      padding: 4px 10px;
    }
  </style>
</head>
<body>
  <h2>My Cart</h2>

  <div class="item">
    <span>Apple</span>
    <span>100</span>
    <span>Qty: <span id="qApple">0</span></span>
    <button onclick="addItem('apple', 100)">Add</button>
  </div>

  <div class="item">
    <span>Banana</span>
    <span>50</span>
    <span>Qty: <span id="qBanana">0</span></span>
    <button onclick="addItem('banana', 50)">Add</button>
  </div>

  <div class="item">
    <span>Orange</span>
    <span>80</span>
    <span>Qty: <span id="qOrange">0</span></span>
    <button onclick="addItem('orange', 80)">Add</button>
  </div>

  <div class="item">
    <span>Grape</span>
    <span>120</span>
    <span>Qty: <span id="qGrape">0</span></span>
    <button onclick="addItem('grape', 120)">Add</button>
  </div>

  <div class="item">
    <span>Pineapple</span>
    <span>150</span>
    <span>Qty: <span id="qPineapple">0</span></span>
    <button onclick="addItem('pineapple', 150)">Add</button>
  </div>

  <h3>Cart</h3>
  <p>Total: <span id="total">0</span></p>

  <script>
    let total = 0;
    let quantities = {
      apple: 0,
      banana: 0,
      orange: 0,
      grape: 0,
      pineapple: 0
    };

    function addItem(name, price) {
      quantities[name]++;
      total += price;

      document.getElementById("qApple").innerText = quantities.apple;
      document.getElementById("qBanana").innerText = quantities.banana;
      document.getElementById("qOrange").innerText = quantities.orange;
      document.getElementById("qGrape").innerText = quantities.grape;
      document.getElementById("qPineapple").innerText = quantities.pineapple;

      document.getElementById("total").innerText = total;

      // Challenge 2
      FlutterChannel.postMessage(total.toString());
    }

    // Challenge 3
    function updateTotalFromFlutter(newTotal) {
      total = newTotal;
      document.getElementById("total").innerText = total;
    }
  </script>
</body>
</html>
""";
