class AuthRoutes {
  static const String login = '/connect/login';
  static const String register = '/connect/register';
}

class OrganizerRoutes {
  static const String dashboard = '/organizer/dashboard';
  static const String profile = '/organizer/profile';
  static const String listKermesse = '/organizer/list-kermesse';
  static const String addKermesse = '/organizer/add-kermesse';
  static const String detailsKermesse = '/organizer/details-kermesse';
  static const String modifyKermesse = '/organizer/modify-kermesse';
  static const String kermesseUsers = '/organizer/kermesse-users';
  static const String kermesseStands = '/organizer/kermesse-stands';
  static const String kermesseTombolas = '/organizer/kermesse-tombolas';
  static const String kermesseParticipations = '/organizer/kermesse-participations';
  static const String kermesseUserInvitation = '/organizer/kermesse-invitation';
  static const String kermesseCreateTombola = '/organizer/kermesse-create-tombola';
  static const String kermesseDetailsTombola = '/organizer/kermesse-details-tombola';
  static const String kermesseModifyTombola = '/organizer/kermesse-modify-tombola';
  static const String kermesseParticipationDetails = '/organizer/kermesse-participation-details';
  static const String userModify = '/organizer/user-modify';
  static const String userDetails = '/organizer/user-details';
  static const String kermesseTickets = '/organizer/kermesse-tickets';
  static const String kermesseTicketDetails = '/organizer/kermesse-ticket-details';
  static const String kermesseDetailsStands = '/organizer/kermesse-details-stands';
  static const String kermesseInvitationStands = '/organizer/kermesse-invitation-stands';
}

class ParentRoutes {
  static const String dashboard = '/parent/dashboard';
  static const String profile = '/parent/profile';
  static const String listKermesse = '/parent/list-kermesse';
  static const String detailsKermesse = '/parent/details-kermesse';
  static const String kermesseChildList = '/parent/kermesse-child-list';
  static const String kermesseStands = '/parent/kermesse-stands';
  static const String kermesseTombolas = '/parent/kermesse-tombolas';
  static const String kermesseParticipations = '/parent/kermesse-participations';
  static const String kermesseParticipationDetails = '/parent/kermesse-participation-details';
  static const String kermesseDetailsTombola = '/parent/kermesse-details-tombola';
  static const String ticketDetails = '/parent/ticket-details';
  static const String listTicket = '/parent/list-ticket';
  static const String kermesseDetailsStands = '/parent/kermesse-details-stands';
  static const String listChild = '/parent/list-child';
  static const String childInvitation = '/parent/child-invitation';
  static const String childDetails = '/parent/child-details';
  static const String userDetails = '/parent/user-details';
  static const String userModify = '/parent/user-modify';
  static const String userModifyBalance = '/parent/user-modify-balance';
  static const String buyJeton = '/parent/user-buy-jeton';
}

class StudentRoutes {
  static const String dashboard = '/student/dashboard';
  static const String userDetails = '/student/profile';
  static const String userModify = '/student/profile-modify';
  static const String listKermesse = '/student/list-kermesse';
  static const String kermesseDetails = '/student/kermesse-details';
  static const String kermesseTombolaList = '/student/kermesse-tombola-list';
  static const String kermesseTombolaDetails = '/student/kermesse-tombola-details';
  static const String kermesseStandList = '/student/kermesse-stand-list';
  static const String kermesseStandDetails = '/student/kermesse-stand-details';
  static const String kermesseParticipationsList = '/student/kermesse-participation-list';
  static const String kermesseParticipationDetails = '/student/kermesse-participation-details';
  static const String listTicket = '/student/list-ticket';
  static const String ticketDetails = '/student/ticket-details';
}

class StandHolderRoutes {
  static const String dashboard = '/stand-holder/dashboard';
  static const String userDetails = '/stand-holder/profile';
  static const String userModify = '/stand-holder/profile-modify';
  static const String listKermesse = '/stand-holder/list-kermesse';
  static const String kermesseDetails = '/stand-holder/kermesse-details';
  static const String kermesseParticipationList = '/stand-holder/kermesse-participation-list';
  static const String kermesseParticipationDetails = '/stand-holder/kermesse-participation-details';
  static const String standAdd = '/stand-holder/stand-add';
  static const String standModify = '/stand-holder/stand-modify';
  static const String standDetails = '/stand-holder/stand-details';
}