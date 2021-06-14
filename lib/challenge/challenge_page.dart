import 'package:DevQuiz/challenge/challenge_controller.dart';
import 'package:DevQuiz/challenge/widget/next_button/next_button_widget.dart';
import 'package:DevQuiz/challenge/widget/question_indicator/question_indicator_widget.dart';
import 'package:DevQuiz/challenge/widget/quiz/quiz_widget.dart';
import 'package:DevQuiz/shared/models/question_model.dart';
import 'package:flutter/material.dart';

class ChallegePage extends StatefulWidget {
  final List<QuestionModel> questions;
  ChallegePage({Key? key, required this.questions}) : super(key: key);

  @override
  _ChallegePageState createState() => _ChallegePageState();
}

class _ChallegePageState extends State<ChallegePage> {
  final controller = ChallengeController();
  final pageController = PageController();

  void nextPage(){
    if (controller.currentPage < widget.questions.length)
      pageController.nextPage(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear
      );
  }

  @override
  void initState() { 
    super.initState();
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(86),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            ValueListenableBuilder<int>(
              valueListenable: controller.currentPageNotifier,
              builder: (context, value, _) => QuestionIndicatorWidget(
              currentPage: value,
              length: widget.questions.length,
            ),
            )
          ],
        ))
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: widget.questions.map((e) => QuizWidget(
          question: e,
          onChange: nextPage
        )).toList()
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ValueListenableBuilder<int>(
            valueListenable: controller.currentPageNotifier,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (value < widget.questions.length)
                Expanded(child: NextButtonWidget.white(label: "Pular", onTap: nextPage)),
                if (value == widget.questions.length)
                  Expanded(child: NextButtonWidget.green(label: "Confirmar", onTap: (){}))
              ],
            )
          ),
        ),
      ),
    );
  }
}