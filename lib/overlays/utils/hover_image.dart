import 'package:flutter/material.dart';

class HoverImage extends StatefulWidget {
  final String normalImage;
  final String hoverImage;
  final VoidCallback onPressed;
  final bool landScape;

  const HoverImage({
    Key? key,
    required this.normalImage,
    required this.hoverImage,
    required this.onPressed,
    this.landScape = false,
  }) : super(key: key);

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        enableFeedback: false,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onPressed,
        onHover: (isHovered) {
          setState(() {
            _isHovered = isHovered;
          });
        },
        child: MouseRegion(
          child: Image.asset(
            _isHovered ? widget.hoverImage : widget.normalImage,
            width: widget.landScape ? 170 : 70,
            height: 70,
          ),
        ),
      ),
    );
  }
}
