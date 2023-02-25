import 'dart:async';

import 'package:dartterm/readline.dart';
import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Terminal',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const TermPage(),
    );
  }
}

class TermPage extends StatefulWidget {
  const TermPage({super.key});

  @override
  State<TermPage> createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  Terminal? _terminal;
  Readline? _readline;
  String title = "Dart Terminal";

  @override
  void initState() {
    super.initState();

    final controller = StreamController<String>();

    _terminal = Terminal(
      onTitleChange: (newTitle) {
        setState(() {
          title = newTitle;
        });
      },
      onOutput: (text) {
        controller.add(text);
      },
    );

    _readline = Readline(
      terminal: _terminal!,
      prompt: '> ',
      continuation: '… ',
    );

    _readline!.run(controller.stream, (line) async {
      _terminal!.write('line: $line\n\r');
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: ColoredBox(
        color: TerminalThemes.defaultTheme.background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TerminalView(_terminal!),
        ),
      ),
    );
  }
}
