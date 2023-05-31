import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.category,
    required this.icon,
  });

  final String category;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 140,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
           color: Colors.white,
        ),
        child: Center(
            child: Row(
              children: [
                Icon(icon),
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}