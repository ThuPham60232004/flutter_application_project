import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';
class JobCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: JobCard(),
        ),
      ),
    );
  }
}
class JobCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin:const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset:const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: const Center(
              child: Text(
                "Logo công ty",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ),
        const  SizedBox(width: 16.0),
          // Job Information
         const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nhân viên Streamer Game - Hồ Chí Minh",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               Text(
                  "CÔNG TY TNHH PHÁT TRIỂN CÔNG NGHỆ BTG",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
               SizedBox(height: 8.0),
               Text(
                  "Hạn nộp: 19/12/2024",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 4.0),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Mức lương: ",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "100.000.000 VND",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.0),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Thành phố: ",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "TP.HCM",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Apply Button
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.zero, 
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: PrimaryTheme.buttonPrimary,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(
                  minWidth: 88.0,
                  minHeight: 36.0,
                ), 
                child: const Text(
                  "Ứng tuyển",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
