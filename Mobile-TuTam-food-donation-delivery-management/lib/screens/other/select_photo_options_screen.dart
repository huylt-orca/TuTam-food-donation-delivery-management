import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/widgets/select_photo_button.dart';
import 'package:image_picker/image_picker.dart';

class SelectPhotoOptionsScreen extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const SelectPhotoOptionsScreen({
    Key? key,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            SelectPhotoButton(
              onTap: () => onTap(ImageSource.gallery),
              icon: Icons.image,
              textLabel: 'Bộ sưu tập',
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Hoặc',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SelectPhotoButton(
              onTap: () => onTap(ImageSource.camera),
              icon: Icons.camera_alt_outlined,
              textLabel: 'Dùng camera',
            ),
          ])
        ],
      ),
    );
  }
}
