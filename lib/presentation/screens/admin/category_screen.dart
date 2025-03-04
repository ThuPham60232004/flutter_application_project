import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final String baseUrl = "https://backend-findjob.onrender.com/category";
  List categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Lỗi khi tải danh sách");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Không thể kết nối đến server");
    }
  }

  Future<void> addCategory(String name, String description) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": name, "description": description}),
      );
      if (response.statusCode == 200) {
        fetchCategories();
        Fluttertoast.showToast(msg: "Thêm thành công");
      } else {
        Fluttertoast.showToast(msg: "Thêm thất bại");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi kết nối đến server");
    }
  }

  Future<void> updateCategory(
      String id, String name, String description) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": name, "description": description}),
      );
      if (response.statusCode == 200) {
        fetchCategories();
        Fluttertoast.showToast(msg: "Cập nhật thành công");
      } else {
        Fluttertoast.showToast(msg: "Cập nhật thất bại");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi kết nối đến server");
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        fetchCategories();
        Fluttertoast.showToast(msg: "Xóa thành công");
      } else {
        Fluttertoast.showToast(msg: "Xóa thất bại");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Không thể xóa dữ liệu");
    }
  }

  void showCategoryDialog({String? id, String? name, String? description}) {
    final nameController = TextEditingController(text: name);
    final descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          id == null ? "Thêm danh mục" : "Chỉnh sửa danh mục",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Tên danh mục"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Mô tả"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (id == null) {
                addCategory(nameController.text, descriptionController.text);
              } else {
                updateCategory(
                    id, nameController.text, descriptionController.text);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quản lý danh mục",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFB276EF), // Màu tím nhạt
              Color(0xFF5A85F4), // Màu xanh dương
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    height: 100,
                    child: ListTile(
                      title: Text(
                        category['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        category['description'] ?? "Không có mô tả",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () => showCategoryDialog(
                              id: category['_id'],
                              name: category['name'],
                              description: category['description'],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteCategory(category['_id']),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryDialog(),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
