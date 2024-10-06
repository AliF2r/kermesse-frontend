import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/routers/organizer_navigation.dart';
import 'package:kermesse_frontend/routers/parent_navigation.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/screens/parent/parent_child_list_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_dashboard_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_details_child_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_details_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_details_participation_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_details_stand_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_details_ticket_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_invitation_child_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_list_children_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_list_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_list_participation_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_list_stand_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_list_ticket_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_user_details_screen.dart';
import 'package:kermesse_frontend/screens/parent/parent_user_modify_screen.dart';
import 'package:provider/provider.dart';


class ParentRouter {
  static final routes = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => ParentNavigation(navigationShell: navigationShell),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: ParentRoutes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentDashboardScreen(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: ParentRoutes.listKermesse,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentListKermesseScreen(),
            ),
          ),
          GoRoute(
            path: ParentRoutes.detailsKermesse,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: ParentDetailsKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: ParentRoutes.kermesseChildList,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: ParentChildListKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: ParentRoutes.kermesseStands,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: ParentListStandKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: ParentRoutes.kermesseDetailsStands,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: ParentDetailsStandKermesseScreen(kermesseId: params['kermesseId']!, standId: params['standId']!),
              );
            },
          ),
          GoRoute(
            path: ParentRoutes.kermesseParticipations,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: ParentListParticipationKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: ParentRoutes.kermesseParticipationDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(child: ParentDetailsParticipationKermesseScreen(kermesseId: params['kermesseId']!, participationId: params['participationId']!),
              );
            },
          ),
        ]
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: ParentRoutes.listTicket,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentListTicketScreen(),
            ),
          ),
          GoRoute(
            path: ParentRoutes.ticketDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: ParentDetailsTicketScreen(ticketId: params['ticketId']!),
              );
            },
          ),
        ]
      ),
      StatefulShellBranch(
          routes: [
            GoRoute(
              path: ParentRoutes.listChild,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ParentListChildrenScreen(),
              ),
            ),
            GoRoute(
              path: ParentRoutes.childDetails,
              pageBuilder: (context, state) {
                final params = GoRouterState.of(context).extra as Map<String, int>;
                return NoTransitionPage(
                  child: ParentDetailsChildScreen(userId: params['userId']!),
                );
              },
            ),
            GoRoute(
              path: ParentRoutes.childInvitation,
              pageBuilder: (context, state) => const NoTransitionPage(
                  child: ParentInvitationChildScreen(),
                ),
            ),
          ]
      ),
      StatefulShellBranch(
          routes: [
            GoRoute(
              path: ParentRoutes.userDetails,
              pageBuilder: (context, state) {
                AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
                return NoTransitionPage(
                  child: ParentUserDetailsScreen(userId: user.id),
                );
              },
            ),
            GoRoute(
              path: ParentRoutes.userModify,
              pageBuilder: (context, state) {
                AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
                return NoTransitionPage(
                  child: ParentUserModifyScreen(userId: user.id),
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