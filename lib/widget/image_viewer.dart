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
      animateToDot(index);
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
    // if (widget.images.length > 1 && widget.images[1] is Image) {
    //   precacheImage((widget.images[1] as Image).image, context);
    // }
    for (Widget image in widget.images) {
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
          onPageChanged: (value) {
            // widget.images.skip(value + 1).take(2).forEach((element) {
            //   if (element is Image) {
            //     precacheImage(element.image, context);
            //   }
            // });
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
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedOpacity(
            opacity: _currentImageIndex > 0 ? 1 : 0,
            duration: const Duration(milliseconds: 300),
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
            duration: const Duration(milliseconds: 300),
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
            height: 14,
            child: IgnorePointer(
              child: ListView.builder(
                controller: _dotsScrollController,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemExtent: 16,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
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
