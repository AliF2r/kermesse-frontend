import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/routers/student_navigation.dart';
import 'package:kermesse_frontend/screens/student/student_dashboard_screen.dart';
import 'package:kermesse_frontend/screens/student/student_details_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/student/student_details_participation_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/student/student_details_stand_screen.dart';
import 'package:kermesse_frontend/screens/student/student_details_ticket_screen.dart';
import 'package:kermesse_frontend/screens/student/student_details_tombola_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/student/student_list_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/student/student_list_participation_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/student/student_list_stand_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/student/student_list_ticket_screen.dart';
import 'package:kermesse_frontend/screens/student/student_list_tombola_kermesse_screen.dart';
import 'package:kermesse_frontend/screens/student/student_user_detail_screen.dart';
import 'package:kermesse_frontend/screens/student/student_user_modify_screen.dart';
import 'package:provider/provider.dart';



class StudentRouter {
  static final routes = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => StudentNavigation(navigationShell: navigationShell),
    branches: [
      _createBranch(StudentRoutes.dashboard, const StudentDashboardScreen()),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: StudentRoutes.listKermesse,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StudentListKermesseScreen(),
            ),
          ),
          GoRoute(
            path: StudentRoutes.kermesseDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: StudentDetailsKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: StudentRoutes.kermesseTombolaList,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: StudentListTombolaKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: StudentRoutes.kermesseTombolaDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: StudentDetailsTombolaKermesseScreen(kermesseId: params['kermesseId']!, tombolaId: params['tombolaId']!),
              );
            },
          ),
          GoRoute(
            path: StudentRoutes.kermesseStandList,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: StudentListStandKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: StudentRoutes.kermesseStandDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: StudentDetailsStandKermesseScreen(kermesseId: params['kermesseId']!, standId: params['standId']!),
              );
            },
          ),
          GoRoute(
            path: StudentRoutes.kermesseParticipationsList,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: StudentListParticipationKermesseScreen(kermesseId: params['kermesseId']!),
              );
            },
          ),
          GoRoute(
            path: StudentRoutes.kermesseParticipationDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(
                child: StudentDetailsParticipationKermesseScreen(kermesseId: params['kermesseId']!, participationId: params['participationId']!),
              );
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: StudentRoutes.listTicket,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StudentListTicketScreen(),
            ),
          ),
          GoRoute(
            path: StudentRoutes.ticketDetails,
            pageBuilder: (context, state) {
              final params = GoRouterState.of(context).extra as Map<String, int>;
              return NoTransitionPage(child: StudentDetailsTicketScreen(ticketId: params['ticketId']!),
              );
            },
          ),
        ]
      ),
      StatefulShellBranch(
          routes: [
            GoRoute(
              path: StudentRoutes.userDetails,
              pageBuilder: (context, state) {
                AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
                return NoTransitionPage(
                  child: StudentUserDetailsScreen(userId: user.id),
                );
              },
            ),
            GoRoute(
              path: StudentRoutes.userModify,
              pageBuilder: (context, state) {
                AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
                return NoTransitionPage(
                  child: StudentUserModifyScreen(userId: user.id),
                );
              },
            ),
          ]
      )
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