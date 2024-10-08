import 'package:flutter/material.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import '../data/stand_data.dart';

class StandDetailsCard extends StatelessWidget {
  final StandDetailsResponse stand;

  const StandDetailsCard({Key? key, required this.stand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppThemeHelper.getStandIcon(stand.category),
                const SizedBox(width: 10),
                Text(
                  stand.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              stand.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: ${stand.price} jeton(s)',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (stand.category == "FOOD")
              Text(
                'Stock: ${stand.stock}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}