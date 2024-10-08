import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/routers/standHolder_navigation.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_add_stand_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_details_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_details_participation_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_details_stand_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_list_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_list_participation_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_modify_stand_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_user_details_screen.dart';
import 'package:kermesse_frontend/screens/stand_holder/standHolder_user_modify_screen.dart';
import 'package:provider/provider.dart';



class StandHolderRouter {
  static final routes = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => StandHolderNavigation(navigationShell: navigationShell),
    branches: [
      StatefulShellBranch(
          routes: [
            GoRoute(
              path: StandHolderRoutes.listKermesse,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: StandHolderListKermesseScreen(),
              ),
            ),
            GoRoute(
              path: StandHolderRoutes.kermesseDetails,
              pageBuilder: (context, state) {
                final params = GoRouterState.of(context).extra as Map<String, int>;
                return NoTransitionPage(
                  child: StandHolderDetailsKermesseScreen(kermesseId: params['kermesseId']!),
                );
              },
            ),
            GoRoute(
              path: StandHolderRoutes.kermesseParticipationList,
              pageBuilder: (context, state) {
                final params = GoRouterState.of(context).extra as Map<String, int>;
                return NoTransitionPage(
                  child: StandHolderListParticipationKermesseScreen(kermesseId: params['kermesseId']!),
                );
              },
            ),
            GoRoute(
              path: StandHolderRoutes.kermesseParticipationDetails,
              pageBuilder: (context, state) {
                final params = GoRouterState.of(context).extra as Map<String, int>;
                return NoTransitionPage(
                  child: StandHolderDetailsParticipationKermesseScreen(kermesseId: params['kermesseId']!, participationId: params['participationId']!),
                );
              },
            ),
          ]
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: StandHolderRoutes.standAdd,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StandHolderAddScreen(),
            ),
          ),
          GoRoute(
            path: StandHolderRoutes.standDetails,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StandHolderDetailsStandScreen(),
            ),
          ),
          GoRoute(
            path: StandHolderRoutes.standModify,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StandHolderModifyScreen(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: StandHolderRoutes.userDetails,
            pageBuilder: (context, state) {
              AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
              return NoTransitionPage(
                child: StandHolderUserDetailsScreen(userId: user.id),
              );
            },
          ),
          GoRoute(
            path: StandHolderRoutes.userModify,
            pageBuilder: (context, state) {
              AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
              return NoTransitionPage(
                child: StandHolderUserModifyScreen(userId: user.id),
              );
            },
          ),
        ],
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