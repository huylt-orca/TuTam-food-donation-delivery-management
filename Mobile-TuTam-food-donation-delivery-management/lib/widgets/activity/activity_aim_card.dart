import 'package:flutter/material.dart';

class ActivityAimCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color colorIcon;

  const ActivityAimCard({
    super.key,
    required this.title,
    required this.colorIcon,
    required this.icon,
    required this.subTitle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        width: MediaQuery.of(context).size.width * 0.5,
        child: Row(
          children: [
            Container(
               padding: const EdgeInsets.all(4.0), 
               margin: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorIcon,
                borderRadius: BorderRadius.circular(20.0),
              ),
             
              child: Icon(
                icon,
                size: 30.0,
                color: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
                ),
                Text(subTitle,
                style: const TextStyle(
                  fontSize: 12
                ),
                )
              ],
            )
          ],
        ));
  }
}