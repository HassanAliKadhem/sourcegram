import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key, required this.images});
  final List<Widget> images;
  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final PageController _pageController = PageController();
  final PageController _dotsPageController =
      PageController(viewportFraction: 1 / 7);
  final Duration _duration = const Duration(milliseconds: 300);

  int _currentImageIndex = 0;
  void animateToPage(int index) {
    if (index > -1 && index < widget.images.length) {
      _pageController.animateToPage(
        index,
        duration: _duration,
        curve: Curves.easeIn,
      );
      // animateToDot(index);
    }
  }

  void animateToDot(int index) {
    _dotsPageController.animateToPage(
      index,
      duration: _duration,
      curve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var image in widget.images) {
      if (image is Image) {
        precacheImage(image.image, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return widget.images[index];
          },
          onPageChanged: (value) {
            animateToDot(value);
            setState(() {
              _currentImageIndex = value;
            });
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedOpacity(
            opacity: _currentImageIndex > 0 ? 1 : 0,
            duration: _duration,
            child: IconButton.filledTonal(
              color: Theme.of(context).iconTheme.color!.withAlpha(200),
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black26)),
              icon: const Icon(Icons.arrow_back),
              onPressed: () => animateToPage(_currentImageIndex - 1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedOpacity(
            opacity: _currentImageIndex < widget.images.length - 1 ? 1 : 0,
            duration: _duration,
            child: IconButton.filledTonal(
              color: Theme.of(context).iconTheme.color!.withAlpha(200),
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black26)),
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => animateToPage(_currentImageIndex + 1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 10,
            width: 14 * 7,
            child: PageView.builder(
              controller: _dotsPageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return AnimatedPadding(
                  duration: _duration,
                  padding: EdgeInsets.all(_currentImageIndex + 2 < index ||
                          _currentImageIndex - 2 > index
                      ? 2.5
                      : 0.0),
                  child: CircleAvatar(
                    backgroundColor:
                        _currentImageIndex == index ? Colors.white : null,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
