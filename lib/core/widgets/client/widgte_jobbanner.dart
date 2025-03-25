import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerCarousel extends StatelessWidget {
  final List<String> images = [
    'https://tienthangvet.vn/wp-content/uploads/thong-tin-tuyen-dung-Tien-Thang-Vet.jpg',
    'https://talentbold.com/uptalent/attachments/images/20211028/151910467_ky-nang-tim-kiem-viec-lam-1.png',
    'https://timviec.com.vn/storage/uploads/images/viec%20lam%20hcm%205.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
        child: CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final imgUrl = images[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => print('Tapped on ${entry.key}'),
                        child: Container(
                          width: 12,
                          height: 12,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(entry.key == index ? 0.9 : 0.4),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 300.0,
            autoPlay: true,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
            },
          ),
        ),
      ),
      )
    );
  }
}
