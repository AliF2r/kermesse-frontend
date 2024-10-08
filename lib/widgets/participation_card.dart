import 'package:flutter/material.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:provider/provider.dart';

Widget buildParticipationCard(BuildContext context, ParticipationList participation) {
  AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 3,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: AppThemeHelper.getColorForRole(user.role),
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participation.user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Used ${participation.balance} jeton(s)',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stand: ${participation.stand.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Description: ${participation.stand.description}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              AppThemeHelper.getStandIcon(participation.stand.category).icon,
              color: AppThemeHelper.getColorForRole(user.role),
            ),
          ],
        ),
      ),
    ),
  );
}