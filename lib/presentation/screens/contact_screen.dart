import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';
import 'package:flutter_application_project/core/widgets/widget_footer.dart';
class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
Widget build(BuildContext context) {
  final inheritedTheme = AppInheritedTheme.of(context);

  return Scaffold(
    appBar: CustomAppBar(
      themeMode: inheritedTheme!.themeMode,
      toggleTheme: inheritedTheme.toggleTheme,
    ),
    body: SingleChildScrollView(
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Liên hệ",
                      style: PrimaryText.primaryTextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('FULL NAME'),
                  _buildTextField('Full Name'),
                  const SizedBox(height: 16),
                  _buildLabel('EMAIL'),
                  _buildTextField('Email Address'),
                  const SizedBox(height: 16),
                  _buildLabel('PHONE'),
                  _buildTextField('Phone #'),
                  const SizedBox(height: 16),
                  _buildLabel('MESSAGE'),
                  _buildTextField('Say oh yah', maxLines: 4),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: PrimaryTheme.buttonPrimary,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          minHeight: 45.0,
                        ),
                        child: const Text(
                          "Gửi câu hỏi",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Những câu hỏi thường xuyên",
                    style: PrimaryText.primaryTextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._buildFAQs(),
                  const SizedBox(height: 20),
                  Text(
                    "Contact Info",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Wrap(
                    spacing: 10,
                    runSpacing: 10, 
                    children: [
                      _buildInfoCard(
                        icon: Icons.home,
                        title: 'Vị trí',
                        content: 'Việt Nam',
                      ),
                      _buildInfoCard(
                        icon: Icons.language,
                        title: 'Thời gian làm việc',
                        content: 'Giờ hành chính',
                      ),
                      _buildInfoCard(
                        icon: Icons.email,
                        title: 'Email',
                        content: 'phamthianhthu6023789@gmail.com',
                      ),
                    ],
                  ),
                ),
            ],)
          ),
           SizedBox(
            height: 330,
            child: CustomFooter(),
          ),
        ],
      ),
    ),
  );
}

List<Widget> _buildFAQs() {
  final faqs = [
    {
      "question": "What is the name of your company",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consequatur quae cumque perspiciatis aperiam accusantium facilis provident aspernatur nisi qui odio debitis dolorem, est eum eligendi vero ad necessitatibus nulla sit labore doloremque magnam?",
    },
    {
      "question": "How much pay for 3 months?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vel ad laborum expedita. Nostrum iure atque enim quisquam minima distinctio omnis.",
    },
    {
      "question": "Do I need to register?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vel ad laborum expedita.",
    },
    {
      "question": "Who should I contact in case of support?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vel ad laborum expedita.",
    },
  ];

  return faqs.map((faq) {
    return buildQuestionSection(faq['question']!, faq['answer']!);
  }).toList();
}

  Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Colors.black),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildTextField(String hintText, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
    );
  }

  Widget buildQuestionSection(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
