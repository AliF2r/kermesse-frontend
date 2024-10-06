import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/routers/organizer_navigation.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_add_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_dashboard_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_invite_user_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_list_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_details_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_modify_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_participation_details_kermesse.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_profile_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_tombola_create_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_tombola_details_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_tombola_list_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_tombola_modify_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_user_list_kermesse_screen.dart';


class OrganizerRouter {
  static final routes = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => OrganizerNavigation(navigationShell: navigationShell),
    branches: [
      _createBranch(OrganizerRoutes.dashboard, const OrganizerDashboardScreen()),
      _createBranch(OrganizerRoutes.profile, const OrganizerProfileScreen()),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: OrganizerRoutes.listKermesse,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: OrganizerListKermesseScreen(),
            ),
          ),
          GoRoute(
            path: OrganizerRoutes.addKermesse,
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: OrganizerAddKermesseScreen(),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.detailsKermesse,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerDetailsKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.modifyKermesse,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerModifyKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.kermesseUsers,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OriganizerUserListKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.kermesseUserInvitation,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerInviteUserKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.kermesseTombolas,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerTombolaListKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.kermesseCreateTombola,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerTombolaCreateKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.kermesseDetailsTombola,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerTombolaDetailsKermesseScreen(tombolaId: params['tombolaId']!, kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.kermesseModifyTombola,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerTombolaModifyKermesseScreen(tombolaId: params['tombolaId']!, kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: OrganizerRoutes.kermesseParticipationDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: OrganizerParticipationDetailsKermesseScreen(kermesseId: params['kermesseId']!, participationId: params['participationId']!,),
              );
            },
          ),
        ]
      ),
    ],
  );

  static StatefulShellBranch _createBranch(String path, Widget screen) {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          pageBuilder: (context, state) => NoTransitionPage(child: screen),
        ),
      ],
    );
  }
}