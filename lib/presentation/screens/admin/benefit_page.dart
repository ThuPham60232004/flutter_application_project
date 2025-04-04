import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BenefitPage extends StatefulWidget {
  @override
  _BenefitPageState createState() => _BenefitPageState();
}

class _BenefitPageState extends State<BenefitPage> {
  final String baseUrl = 'https://backend-findjob.onrender.com/benefit';
  List<dynamic> _benefits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBenefits();
  }

  Future<void> _fetchBenefits() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          _benefits = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load benefits');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lỗi tải danh sách phúc lợi: ${e.toString()}')));
    }
  }

  Future<void> _saveBenefit(Map<String, String> benefit, {String? id}) async {
    try {
      final url = id != null ? '$baseUrl/$id' : baseUrl;
      final response = await (id != null
          ? http.put(Uri.parse(url),
              body: jsonEncode(benefit),
              headers: {'Content-Type': 'application/json'})
          : http.post(Uri.parse(url),
              body: jsonEncode(benefit),
              headers: {'Content-Type': 'application/json'}));
      if (response.statusCode == 200) {
        _fetchBenefits();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lưu thành công!')));
      } else {
        throw Exception('Failed to save benefit');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi lưu phúc lợi: ${e.toString()}')));
    }
  }

  // Xóa phúc lợi
  Future<void> _deleteBenefit(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        _fetchBenefits();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xóa thành công!')));
      } else {
        throw Exception('Failed to delete benefit');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi xóa phúc lợi: ${e.toString()}')));
    }
  }

  void _showBenefitForm({Map<String, dynamic>? benefit}) async {
  final isEdit = benefit != null;
  final nameController = TextEditingController(text: isEdit ? benefit['name'] : '');
  final descriptionController = TextEditingController(text: isEdit ? benefit['description'] : '');
  final iconController = TextEditingController(text: isEdit ? benefit['icon'] : '');

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for the dialog
      ),
      title: Text(
        isEdit ? 'Chỉnh sửa phúc lợi' : 'Thêm phúc lợi',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.deepPurple,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên phúc lợi (Làm rộng ra)
            Container(
              width: double.infinity, // Chiếm toàn bộ chiều ngang của AlertDialog
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên phúc lợi',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Điều chỉnh chiều ngang
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Mô tả phúc lợi (Làm rộng ra)
            Container(
              width: double.infinity, // Chiếm toàn bộ chiều ngang của AlertDialog
              child: TextField(
                controller: descriptionController,
                maxLines: 5,  // Cho phép mô tả dài ra
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Điều chỉnh chiều ngang
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Icon (Làm rộng ra)
            Container(
              width: double.infinity, // Chiếm toàn bộ chiều ngang của AlertDialog
              child: TextField(
                controller: iconController,
                decoration: InputDecoration(
                  labelText: 'Icon',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Điều chỉnh chiều ngang
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Hủy
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Hủy',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Lưu
        ElevatedButton(
          onPressed: () {
            final benefitData = {
              'name': nameController.text,
              'description': descriptionController.text,
              'icon': iconController.text,
            };
            Navigator.of(context).pop();
            _saveBenefit(benefitData, id: isEdit ? benefit['_id'] : null);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
          child: const Text(
            'Lưu',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}


  IconData getIconForBenefit(String name) {
    switch (name.toLowerCase()) {
      case 'chế độ bảo hiểm':
        return Icons.health_and_safety;
      case 'chế độ thưởng':
        return Icons.card_giftcard;
      case 'phụ cấp nhà ở':
        return Icons.home;
      case 'đào tạo':
        return Icons.school;
      case 'chăm sóc sức khoẻ':
        return Icons.local_hospital;
      case 'du lịch':
        return Icons.flight_takeoff;
      case 'công việc ổn định':
        return Icons.work;
      case 'tăng lương':
        return Icons.trending_up;
      case 'nghỉ phép năm':
        return Icons.beach_access;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Quản lý phúc lợi',
            style: TextStyle(
              fontWeight: FontWeight.bold, // In đậm chữ
              fontSize: 18, // Điều chỉnh kích thước chữ nếu cần
            ),
          ),
          centerTitle: true, // Căn giữa tiêu đề
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFB276EF), 
                  Color(0xFF5A85F4), 
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent, 
          elevation: 0, 
        ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _benefits.isEmpty
              ? Center(child: Text('Không có phúc lợi nào'))
              : ListView.builder(
                  itemCount: _benefits.length,
                  itemBuilder: (context, index) {
                    final benefit = _benefits[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(benefit['name']),
                        subtitle:
                            Text(benefit['description'] ?? 'Không có mô tả'),
                        leading: Icon(getIconForBenefit(benefit['name'])),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.deepPurple, 
                                ),
                                onPressed: () => _showBenefitForm(benefit: benefit),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                 color: Colors.red, 
                                onPressed: () => _deleteBenefit(benefit['_id']),
                              ),
                            ],
                          ),

                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBenefitForm(),
        child: Icon(
          Icons.add,
          color: Colors.white, // Màu trắng cho biểu tượng
        ),
        backgroundColor: Colors.deepPurple, // Màu nền của nút là deepPurple
      ),
    );
  }
}
