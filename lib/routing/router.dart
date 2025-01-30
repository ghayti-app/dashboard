 import 'package:admin_dashboard/pages/admins/widgets/show_admins/show%20admins_history.dart';
  import 'package:admin_dashboard/pages/coupon/add_coupon.dart';
 import 'package:admin_dashboard/pages/drivers/widgets/show%20drivers/show_drivers_widgets.dart';
import 'package:admin_dashboard/pages/overview/overview.dart';
import 'package:admin_dashboard/pages/ride%20request/new_ride_request.dart';
import 'package:admin_dashboard/pages/tickets/tickets.dart';
 import 'package:admin_dashboard/pages/users/widgets/show%20users/show_users_widgets.dart';
import 'package:admin_dashboard/pages/wallet%20request/riderequest_money.dart';
import 'package:admin_dashboard/pages/transactions.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/pages/show_heap_location.dart';
import 'package:flutter/material.dart';
import '../pages/admins/widgets/add_admins.dart';
import '../pages/admins/widgets/show_admins/show admins_widgets.dart';
 import '../pages/coupon/show_coupon/show_coupon_widgets.dart';
import '../pages/services/add_services.dart';
import '../pages/services/show_services_widgets.dart';
import '../pages/ride request/showRideRequestServices.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // to open the page and the drawer will be apear
  switch (settings.name) {
    // case '/':
    //   return MaterialPageRoute(builder: (context) => OverviewPage());
    case overViewPageRoute:
      return getPageRoute(const OverviewPage()); 
    case addAdminPageRoute:
      return
      //  MaterialPageRoute(
      //     builder: (context) =>
      //         AddAdminsWidgets());  ClientsPage 
          //    getPageRoute(const AddAdminsWidgets());
              getPageRoute(const AddAdminsWidgets());
    case showAdminsPageRoute:
      return getPageRoute(const ShowAdminsTable()); 
 
    case showAdminHistoryPageRoute:
      return
      //  MaterialPageRoute(
      //     builder: (context) =>
      //         ShowAdminWidgets());
               getPageRoute(const ShowAdminsHistory());
    // case addDriversPageRoute:
    //   return getPageRoute(AddDriversWidgets());
    case showDriversPageRoute:
      return getPageRoute( ShowDriversTable());
    // case addusersPageRoute:
    //   return getPageRoute(AddUsersWidgets());
    case showusersPageRoute:
      return getPageRoute(const ShowUsersTable());
    case showRidePageRoute: 
      return getPageRoute(const RideRequestServicesWidgets());
    case newBookingPageRoute: 
      return getPageRoute(  const NewBookingScreen());  // new ride request
   
    case addServicesPageRoute:
      return getPageRoute(const AddServiceScreen());
    case showServicesPageRoute:
      return getPageRoute(  ShowServiceScreen());

    // case addDocumentPageRoute:
    //   return getPageRoute(AddDocumentWidgets());
    // case showDocumentPageRoute:
    //   return getPageRoute(const ShowDocumentWidgets());
    case addcouponPageRoute: 
      return getPageRoute(const AddCouponScreen());
    case showcouponPageRoute:
      return getPageRoute(  ShowCouponWidgets());
    case showUserLocationsPageRoute:
      return getPageRoute(const UserLocationsScreen());

    case showWalletPageRoute:
      return getPageRoute(const ShowWalletTable());
    case TransactionPageRoute:
      return getPageRoute(const Transaction());
    case ticketPageRoute:
      return getPageRoute(  TicketsScreen());
    //     case settingsRoutePage:
    // return getPageRoute(const Settings());

    // case ticketMessagesPageRoute:
    // return getPageRoute(  ShowMessages());
    /////////////////to solve //////////////////////////
    case driversPageRoute:
      return getPageRoute(  const ShowAdminsTable());
    // case authenticationPageRoute:
    //   // return Navigator.pushAndRemoveUntil(
    //   //   context,
    //   //   AuthenticationPage(),
    //   //   (route) {
    //   //     return false;
    //   //   },
    //   // );
    //   return getPageRoute(const AuthenticationPage());
    default:
      return getPageRoute(const OverviewPage());
  }
}

PageRoute getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

// List<GetPage<dynamic>>? routes = [
//   GetPage(
//       name: "/", page: () => const Language(), middlewares: [MyMiddleWare()]),
// ];
