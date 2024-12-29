import 'package:flutter/material.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/widgets/widget_jobcard.dart';
class CompanyDetail extends StatefulWidget {
  const CompanyDetail({Key? key}) : super(key: key);
  @override
  _CompanyDetailState createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail> {
  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/3/3f/LG_logo_%282015%29.svg',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MB Bank',
                            style: PrimaryText.primaryTextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.black, size: 16),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Da Nang - Others - Ha Noi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.work_outline, color: Colors.black, size: 16),
                              SizedBox(width: 4),
                              Text(
                                '5 job openings',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
            SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(10, (index) => JobCard()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
