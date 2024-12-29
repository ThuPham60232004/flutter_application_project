import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/widget_drawer.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/widget_search.dart';
import 'package:flutter_application_project/core/widgets/widgte_jobbanner.dart';
import 'package:flutter_application_project/core/widgets/widget_footer.dart';
class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  double _scrollOffset = 0.0;
  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      drawer: CustomDrawer(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _scrollOffset = scrollNotification.metrics.pixels;
            });
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: SizedBox(
                  height: 80,
                  child: WidgetSearch(),
                ),
              ),
              SizedBox(
                height: 200,
                child: BannerCarousel(),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Danh Sách Các Công Ty Nổi Bật',
                  style: PrimaryText.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(10, (index) => _buildCompanyCard()),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 330,
                child: CustomFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Image.network(
              'https://nhanlucnganhluat.vn/uploads/images/BBD5FCBE/logo/2023-03/logo.jpg',
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
          ),
          Text(
            'MB Bank',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hà Nội',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '3 công việc',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
