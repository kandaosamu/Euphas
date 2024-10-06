import 'package:euphas/config/constants.dart';
import 'package:euphas/pages/patient/quiz_subcategory.dart';
import 'package:euphas/services/firestore.dart';
import 'package:euphas/ui/card_button.dart';
import 'package:flutter/material.dart';

class QuizCategory extends StatefulWidget {
  const QuizCategory({super.key});

  @override
  State<QuizCategory> createState() => _QuizCategoryState();
}

class _QuizCategoryState extends State<QuizCategory> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FireStoreService().getCategory(),
        builder: (context, future) {
          final categories = future.data;
          if (future.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (future.hasData) {
            return GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: (screenWidth * 0.4) / (screenHeight * 0.3),
              mainAxisSpacing: screenHeight * 0.01,
              crossAxisSpacing: screenWidth * 0.01,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
              children: List.generate(future.data!.length, (index) {
                return CardButton(
                    title: categories?[index]['title'],
                    enabled: categories?[index]['sub_categories'].length > 0 ? true : false,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuizSubCategory(category: categories?[index]['title'])));
                    });
              }),
            );
          } else {
            return Center(child: Text(future.error.toString()));
          }
        });
  }
}