import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic>? photosUrlsOriginal;

  const ImageSlider({Key? key, required this.photosUrlsOriginal})
      : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  Widget createCircle(int index) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.all(1.4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (index == _current) ? Colors.blue : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photosUrlsOriginal == null ||
        widget.photosUrlsOriginal!.isEmpty) {
      return const SizedBox();
    }
    List<Widget> circles = List.generate(
        widget.photosUrlsOriginal!.length, (index) => createCircle(index));
    bool singleImage = widget.photosUrlsOriginal!.length == 1;
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.photosUrlsOriginal!.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.photosUrlsOriginal![itemIndex],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
          options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: singleImage ? 1 : 0.815,
              aspectRatio: 1,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          carouselController: _controller,
        ),
        const SizedBox(height: 10),
        singleImage
            ? const SizedBox()
            : SizedBox(
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: circles,
                  ),
                ),
              ),
      ],
    );
  }
}
