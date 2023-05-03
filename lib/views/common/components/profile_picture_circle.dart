import 'package:club_model/club_model.dart';
import 'package:flutter/material.dart';

class ProfilePictureCircle extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const ProfilePictureCircle({Key? key,required this.imageUrl,this.width=50,this.height=50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          placeholder: (context, _) {
            return Shimmer.fromColors(
              baseColor: themeData.scaffoldBackgroundColor,
              highlightColor: themeData.colorScheme.background,
              child: Container(
                alignment: Alignment.center,
                color: themeData.secondaryHeaderColor,
                child: const Icon(
                  Icons.image,
                  size: 40,
                ),
              ),
            );
          },
          errorWidget: (___, __, _) {
            return Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
            );
          },
        ),
        ),
    );
  }
}
