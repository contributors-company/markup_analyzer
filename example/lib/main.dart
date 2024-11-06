import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final String string = 'Hello, World';
  final int counter = 42;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello, World'),

            // 2. PrefixedIdentifier()
            Text(widget
                .title), // Предполагается, что widget.title определен в StatefulWidget

            // 3. StringInterpolation()
            Text('Количество кликов: $counter'),

            // 4. BinaryExpression with +
            Text('Hello' ' World'),

            // 5. AdjacentStrings
            Text(
              'Hello, '
              'world!',
            ),

            // 6. MethodInvocation()
            Text('Hello'.toString()),

            // 7. SimpleIdentifier()
            Text(string),

            // 8. FunctionExpressionInvocation or PropertyAccess
            Text(Theme.of(context).textTheme.headlineMedium.toString()),

            // 9. NamedExpression()
            Text(
              'Заголовок',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
