import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.green,),
          IconButton(
              onPressed: (){
                context.go('/signIn');
              },
              icon: Icon(Icons.backspace),
          )
        ],
      )
    );
  }
}
