const rootRoute = "/home";
const notFoundRoute = "/not-found";

const overViewPageDisplayName = "Overview";
const overViewPageRoute = "/overview";

const showUserLocationsName = "Show Online Users Location";
const showUserLocationsPageRoute = "/showuserlocations";

const adminsName = "Admins"; //ShowAdminsHistory
const adminsPageRoute = "/admin";
const addAdminName = "add Admins";
const addAdminPageRoute = "/admin/add";
const showAdminHistoryName = "Admins Actions";
const showAdminHistoryPageRoute = "/admin/action";
const showAdminsName = "show Admins";
const showAdminsPageRoute = "/admin/show";

const driversName = "Drivers"; 
const driversPageRoute = "/driver";
// const addDriversName = "add Driver" ;
// const addDriversPageRoute = "/driver/add";
const showDriversName = "show Drivers";
const showDriversPageRoute = "/driver/show";

const usersName = "Users";
const usersPageRoute = "/user";
// const addusersName = "add User" ;
// const addusersPageRoute = "/user/add";
const showusersName = "show Riders";
const showusersPageRoute = "/user/show";

const servicesName = "services";
const servicesPageRoute = "/services";
const showServicesName = "show Services";
const showServicesPageRoute = "/services/show";
const addServicesName = "add Service";
const addServicesPageRoute = "/services/add";

const documentName = "Document";
const documentPageRoute = "/document";
const showDocumentName = "show Documents";
const showDocumentPageRoute = "/document/show";
const addDocumentName = "add Document";
const addDocumentPageRoute = "/document/add";

const rideRequestName = "Ride Requests";
const rideRequestPageRoute = "/riderequest";
const showRideName = "Show Ride Request";
const showRidePageRoute = "/showriderequest";
const newBookingName = "New Booking";
const newBookingPageRoute = "/newbooking";

const showWalletName = "Show Wallet Request";
const showWalletPageRoute = "/showwalletrequest";

const TransactionName = "Transaction Page";
const TransactionPageRoute = "/transaction";

const couponName = "Coupons";
const couponPageRoute = "/coupon";
const showcouponName = "show Coupons";
const showcouponPageRoute = "/coupon/show";
const addcouponName = "add Coupons";
const addcouponPageRoute = "/coupon/add";

const authenticationDisplayName = "Log Out"; //languagePageRoute
const authenticationPageRoute = "/auth";

// const settingsName = "settings" ;
// const settingsRoutePage = "/settings"; //ticketPageRoute

const languageName = "language";
const languageRoutePage = "/language"; //ticketPageRoute
const ticketName = "ticket";
const ticketPageRoute = "/ticket"; //ticketPageRoute

const ticketMessagesName = "ticket masseges";
const ticketMessagesPageRoute = "/ticketMesssages"; //ticketPageRoute

class MenuItem {
  final String name;
  final String route;

  MenuItem({required this.name, required this.route});
}

List<MenuItem> sideMenuItems = [
  // to add a menu in drawer
  MenuItem(name: overViewPageDisplayName, route: overViewPageRoute),

  // MenuItem(name: productsPageDisplayName, route: productsPageRoute),

  MenuItem(name: adminsName, route: adminsPageRoute),
  MenuItem(name: driversName, route: driversPageRoute),
  MenuItem(name: usersName, route: usersPageRoute),

  MenuItem(name: servicesName, route: servicesPageRoute),

  // MenuItem(name: documentName, route: documentPageRoute),

  MenuItem(name: couponName, route: couponPageRoute),
  MenuItem(name: rideRequestName, route: rideRequestPageRoute),
  //  MenuItem(name: showRideName, route: showRidePageRoute),

  MenuItem(name: showWalletName, route: showWalletPageRoute),
  MenuItem(name: TransactionName, route: TransactionPageRoute),

  MenuItem(name: showUserLocationsName, route: showUserLocationsPageRoute),
  // MenuItem(name: settingsName, route: settingsRoutePage),
  MenuItem(name: ticketName, route: ticketPageRoute),

  // MenuItem(name: authenticationDisplayName, route: authenticationPageRoute),
];

class SubMenuItem {
  final String name;
  final String route;

  SubMenuItem({required this.name, required this.route});
}

List<SubMenuItem> adminsSubItems = [
  //admins
  SubMenuItem(name: showAdminsName, route: showAdminsPageRoute),
  SubMenuItem(name: addAdminName, route: addAdminPageRoute),
  SubMenuItem(name: showAdminHistoryName, route: showAdminHistoryPageRoute),
  //drivers
  SubMenuItem(name: showDriversName, route: showDriversPageRoute),
  // SubMenuItem(name: addDriversName, route: addDriversPageRoute),
  //users
  SubMenuItem(name: showusersName, route: showusersPageRoute),
  // SubMenuItem(name: addusersName, route: addusersPageRoute),

  //services
  SubMenuItem(name: showusersName, route: showServicesPageRoute),
  // SubMenuItem(name: addusersName, route: addServicesPageRoute),

  // SubMenuItem(name: showusersName, route: showServicesPageRoute),
  // SubMenuItem(name: addServicesName, route: addServicesPageRoute),

  // // SubMenuItem(name: showDocumentName, route: showDocumentPageRoute),
  // // SubMenuItem(name: addDocumentName, route: addDocumentPageRoute),

  // SubMenuItem(name: showcouponName, route: showcouponPageRoute),
  // SubMenuItem(name: addcouponName, route: addcouponPageRoute),
];
