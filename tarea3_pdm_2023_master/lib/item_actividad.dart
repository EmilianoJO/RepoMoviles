import 'package:flutter/material.dart';

class ItemActividad extends StatelessWidget {
  // ItemActividad({super.key});

  int index = 0;
  List names = ["Bali mountains", "Tulum", "Punta Cana", "San Lucas", "Cancún"];

  ItemActividad(this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            width: 120,
            child: Image.asset(
              'images/$index.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Text("Day $index", style: TextStyle(fontSize: 11)),
          Text(names[index - 1]),
        ],
      ),
    );
  }
}
