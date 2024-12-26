import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';

class JobCard extends StatelessWidget {
  const JobCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = _JobCardColors(isDarkMode);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: colors.borderColor, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _JobDetails(colors: colors),
          const SizedBox(height: 16.0),
          _ApplyButton(),
        ],
      ),
    );
  }
}
class _JobDetails extends StatelessWidget {
  final _JobCardColors colors;
  const _JobDetails({required this.colors});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompanyLogo(borderColor: colors.borderColor),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nhân viên Streamer Game - Hồ Chí Minh",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: colors.titleColor,
                ),
              ),
              Text(
                "CÔNG TY TNHH PHÁT TRIỂN CÔNG NGHỆ BTG",
                style: TextStyle(
                  fontSize: 12.0,
                  color: colors.subtitleColor,
                ),
              ),
              const SizedBox(height: 4.0),
              _RichTextRow(
                label: "Mức lương: ",
                value: "100.000.000 VND",
                colors: colors,
              ),
              const SizedBox(height: 4.0),
              _RichTextRow(
                label: "Thành phố: ",
                value: "TP.HCM",
                colors: colors,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _CompanyLogo extends StatelessWidget {
  final Color borderColor;
  const _CompanyLogo({required this.borderColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: const Center(
        child: Text(
          "Logo công ty",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Color(0xFF90A4AE)),
        ),
      ),
    );
  }
}
class _RichTextRow extends StatelessWidget {
  final String label;
  final String value;
  final _JobCardColors colors;
  const _RichTextRow({
    required this.label,
    required this.value,
    required this.colors,
  });
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(fontSize: 12.0, color: colors.subtitleColor),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: colors.titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
class _ApplyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: PrimaryTheme.buttonPrimary,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          alignment: Alignment.center,
          width: 60.0,
          constraints: const BoxConstraints(
            minWidth: 100.0,
            minHeight: 36.0,
          ),
          child: const Text(
            "Ứng tuyển",
            style: TextStyle(fontSize: 12.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
class _JobCardColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;

  _JobCardColors(bool isDarkMode)
      : backgroundColor = isDarkMode ? const Color(0xFF263238) : const Color(0xFFF7F9FC),
        borderColor = isDarkMode ? const Color(0xFF37474F) : const Color(0xFFB0BEC5),
        titleColor = isDarkMode ? const Color(0xFFECEFF1) : const Color(0xFF263238),
        subtitleColor = isDarkMode ? const Color(0xFFB0BEC5) : const Color(0xFF546E7A);
}
