import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/widgets/widget_footer.dart';
class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key}) : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
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
            Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children:[_buildUpdateAndPublishDate(),
                  SizedBox(height: 10),
                  _buildBlogTitle(),
                  SizedBox(height: 16),
                  _buildBlogImage(),
                  SizedBox(height: 16),
                  _buildIntroText(),
                  SizedBox(height: 16),
                  _buildSectionTitle('Google Colab là gì?'),
                  SizedBox(height: 8),
                  _buildParagraph(
                    'Google Colab là một công cụ mạnh mẽ và tiện lợi cho việc viết và chạy mã Python trực tuyến, đặc biệt phù hợp với các nhà khoa học dữ liệu, lập trình viên, và những người mới học lập trình.'
                  ),
                  SizedBox(height: 24),
                  Divider(),
                  SizedBox(height: 16),
                  _buildShareSection(),
                  _buildTagSection(),
                  SizedBox(height: 24),
                  Divider(),
                  SizedBox(height: 16),
                  _buildRecentBlogsSection(),
                  SizedBox(height: 24),
                  Divider(),
                  SizedBox(height: 16),
                  _buildAuthorSection(),
                ]
              )
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

  Widget _buildUpdateAndPublishDate() {
    return Text(
      'Ngày cập nhật: 06/12/2024\nNgày xuất bản: 06/12/2024',
      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
    );
  }

  Widget _buildBlogTitle() {
    return Text(
      'Google Colab là gì? Hướng dẫn code Python với Google Colab',
      style: PrimaryText.primaryTextStyle1(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBlogImage() {
    return Image.network(
      'https://static1.anpoimages.com/wordpress/wp-content/uploads/2023/03/colab.jpg',
      fit: BoxFit.cover,
    );
  }

  Widget _buildIntroText() {
    return Text(
      'Google Colab là một nền tảng đám mây cho phép người dùng viết và thực thi mã Python trong môi trường cộng tác. Nó cung cấp quyền truy cập vào các tài nguyên điện toán mạnh mẽ, bao gồm GPU và tạo điều kiện chia sẻ Notebook, giúp Google Colab trở thành một công cụ lý tưởng cho mục đích thực hành code Python trong các dự án phân tích dữ liệu, học máy, v.v.',
      style: TextStyle(fontSize: 16, height: 1.5),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, height: 1.5),
    );
  }

  Widget _buildShareSection() {
    return Row(
      children: [
        Text(
          "Chia sẻ bài viết:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.facebook),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.tiktok),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.youtube_searched_for),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTagSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TAG:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text("Chia sẻ chuyên môn"), backgroundColor: Colors.grey[200]),
            Chip(label: Text("Tài liệu Python"), backgroundColor: Colors.grey[200]),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentBlogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Blog gần nhất"),
        SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBlogItem("Top 30+ câu hỏi phỏng vấn DevOps phổ biến"),
            _buildBlogItem("Top 10 plugin tốt nhất cho ReactJS"),
            _buildBlogItem("ReactJS là gì: Tính năng nổi bật, cách hoạt động và Lifecycle"),
            _buildBlogItem("Top 40+ câu hỏi phỏng vấn Java nhất định có trong buổi phỏng vấn"),
            _buildBlogItem("Top 40+ câu hỏi phỏng vấn Kotlin sẽ gặp trong buổi phỏng vấn"),
          ],
        ),
      ],
    );
  }

  Widget _buildBlogItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Tác giả"),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://th.bing.com/th/id/OIP.7UT91Bm_XOzcwYWJSYTpPgHaHa?rs=1&pid=ImgDetMain',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nguyễn Hữu Văn",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Data Engineer",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Văn Nguyễn là một kỹ sư dữ liệu đã và đang làm việc tại nhiều tập đoàn đa quốc gia như Tripadvisor, ST Engineering. Đã từng làm việc ở nhiều vị trí liên quan đến cơ sở dữ liệu như Chuyên viên phân tích (Data analyst), Kỹ sư (Data engineer), Nghiên cứu và phát triển các sản phẩm Machine Learning cho lĩnh vực tài chính và nông nghiệp.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
