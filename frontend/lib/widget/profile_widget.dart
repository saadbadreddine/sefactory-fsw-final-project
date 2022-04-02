import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 180,
        color: Theme.of(context).colorScheme.background,
        width: MediaQuery.of(context).size.width,
        child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(child: buildImage(context), top: 85),
              Positioned(
                top: 195,
                right: 140,
                child: buildEditIcon(context),
              ),
            ]),
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Theme.of(context).colorScheme.onBackground,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 150,
          height: 150,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(BuildContext context) => buildCircle(
        color: Theme.of(context).colorScheme.onPrimary,
        all: 1,
        child: buildCircle(
          color: Theme.of(context).colorScheme.primary,
          all: 8,
          child: isEdit
              ? Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                )
              : Icon(
                  Icons.add_photo_alternate,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
