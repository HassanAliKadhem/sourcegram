import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key, required this.images});
  final List<Widget> images;
  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final PageController _pageController = PageController();
  final ScrollController _dotsScrollController = ScrollController();

  int _currentImageIndex = 0;
  void animateToPage(int index) {
    if (index > -1 && index < widget.images.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void animateToDot(int index) {
    _dotsScrollController.animateTo(
      16.0 * index > _dotsScrollController.position.maxScrollExtent
          ? _dotsScrollController.position.maxScrollExtent
          : 16.0 * index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.images.length > 1 && widget.images[1] is Image) {
      precacheImage((widget.images[1] as Image).image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          onPageChanged: (value) {
            widget.images.skip(value + 1).take(2).forEach((element) {
              if (element is Image) {
                precacheImage(element.image, context);
              }
            });
            animateToDot(value);
            setState(() {
              _currentImageIndex = value;
            });
          },
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return widget.images[index];
          },
        ),
        if (_currentImageIndex > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton.filledTonal(
                onPressed: () => animateToPage(_currentImageIndex - 1),
                icon: const Icon(Icons.arrow_back)),
          ),
        if (_currentImageIndex < widget.images.length - 1)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton.filledTonal(
                onPressed: () => animateToPage(_currentImageIndex + 1),
                icon: const Icon(Icons.arrow_forward)),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 20,
            child: IgnorePointer(
              child: ListView.builder(
                controller: _dotsScrollController,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemExtent: 16,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: CircleAvatar(
                      radius: 6.0,
                      backgroundColor:
                          _currentImageIndex == index ? Colors.white : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
