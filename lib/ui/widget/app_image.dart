import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppImage extends StatefulWidget {
  const AppImage({
    super.key,
    required this.imageUrl,
    this.boxFit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.height,
    this.width,
  });

  final String imageUrl;
  final BoxFit boxFit;
  final BoxShape shape;
  final double? borderRadius;
  final double? height;
  final double? width;

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.shape == BoxShape.rectangle) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        child: CachedNetworkImage(
          height: widget.height,
          width: widget.width,
          imageUrl: widget.imageUrl,
          fit: widget.boxFit,
          placeholder: (context, url) {
            return Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              ),
              child: CupertinoActivityIndicator(),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              ),
              child: Icon(Icons.error),
            );
          },
        ),
      );
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: widget.boxFit,
        height: widget.height,
        width: widget.width,
        placeholder: (context, url) {
          return ClipOval(
            child: Container(
              color: Colors.grey.withValues(alpha: 0.5),

              height: widget.height,
              width: widget.width,
              child: CupertinoActivityIndicator(),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return ClipOval(
            child: Container(
              color: Colors.grey.withValues(alpha: 0.5),
              height: widget.height,
              width: widget.width,
              child: Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
}
