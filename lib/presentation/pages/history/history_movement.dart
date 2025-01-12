import 'package:flutter/material.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';


class HistoryMovement extends StatelessWidget {
  const HistoryMovement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar()
      ),
      body: const Center(
        child: Text("Movement"),
      ),
    );
  }
}