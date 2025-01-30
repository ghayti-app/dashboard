 
// GeneralButton(
//                       text: "confirm",
//                       onPressed: () async {
//                         bool ok = true;

//                         if (HomeCubit.get(context).selectedService != null) {
//                           //    log(ok.toString());
//                           if (controller.text.isNotEmpty) {
//                             ok = await HomeCubit.get(context).checkCoupon(
//                                 context,
//                                 cost: GeneralHelper.calculationTotalCashDouble(
//                                     minimumFare: HomeCubit.get(context)
//                                         .services[HomeCubit.get(context)
//                                             .selectedService!]
//                                         .minimumFare,
//                                     serviceTimeList: HomeCubit.get(context)
//                                         .services[HomeCubit.get(context)
//                                             .selectedService!]
//                                         .serviceTimeList,
//                                     cost: HomeCubit.get(context)
//                                         .services[HomeCubit.get(context)
//                                             .selectedService!]
//                                         .costPerKilo
//                                         .toDouble(),
//                                     totalDistance: HomeCubit.get(context)
//                                         .directions!
//                                         .totalDistance),
//                                 serviceName: HomeCubit.get(context).services[HomeCubit.get(context).selectedService!].name,
//                                 coupon: controller.text.trim());
//                           }

//                           if (ok == true) {
//                             if (HomeCubit.get(context).startLocation != null &&
//                                 HomeCubit.get(context).endLocation != null &&
//                                 HomeCubit.get(context).startAddressName != '' &&
//                                 HomeCubit.get(context).endAddressName != '' &&
//                                 HomeCubit.get(context).directions != null) {
//                               String? token =
//                                   await FirebaseMessaging.instance.getToken();
//                               await HomeCubit.get(context).confirmRideRequest(
//                                   RideRequestModel(
//                                       driverToken: "none",
//                                       userToken: "$token",
//                                       finalCostPerKilo:
//                                           GeneralHelper.calculationCostPerKilo(
//                                               cost: HomeCubit.get(context)
//                                                   .services[HomeCubit.get(context)
//                                                       .selectedService!]
//                                                   .costPerKilo
//                                                   .toDouble(),
//                                               serviceTimeList: HomeCubit.get(context)
//                                                   .services[HomeCubit.get(context)
//                                                       .selectedService!]
//                                                   .serviceTimeList),
//                                       driverPhoneNumber: "",
//                                       userPhoneNumber: FirebaseAuth
//                                           .instance.currentUser!.phoneNumber!,
//                                       isFreeRide:
//                                           HomeCubit.get(context).isFreeRide,
//                                       couponID:
//                                           CashHelper.getString(key: Keys.couponID) ??
//                                               "none",
//                                       discountAmount: CashHelper.getDouble(
//                                               key: Keys.couponAmount) ??
//                                           0.0,
//                                       canceledBy: "none",
//                                       driverLat: 0.0,
//                                       driverLng: 0.0,
//                                       userName: CashHelper.getString(key: Keys.userName) ?? "",
//                                       userId: FirebaseAuth.instance.currentUser!.uid,
//                                       startLat: HomeCubit.get(context).startLocation!.latitude,
//                                       startLng: HomeCubit.get(context).startLocation!.longitude,
//                                       startAddress: HomeCubit.get(context).startAddressName,
//                                       endAddress: HomeCubit.get(context).endAddressName,
//                                       endLat: HomeCubit.get(context).endLocation!.latitude,
//                                       endLng: HomeCubit.get(context).endLocation!.longitude,
//                                       driverName: "none",
//                                       driverId: "none",
//                                       carModel: "none",
//                                       carPlateNumber: "none",
//                                       state: "new_ride_request",
//                                       duration: HomeCubit.get(context).directions!.totalDuration,
//                                       distance: HomeCubit.get(context).directions!.totalDistance,
//                                       service: HomeCubit.get(context).services[HomeCubit.get(context).selectedService!].name,
//                                       cost: GeneralHelper.calculationTotalCash(minimumFare: HomeCubit.get(context).services[HomeCubit.get(context).selectedService!].minimumFare, serviceTimeList: HomeCubit.get(context).services[HomeCubit.get(context).selectedService!].serviceTimeList, cost: HomeCubit.get(context).services[HomeCubit.get(context).selectedService!].costPerKilo.toInt(), totalDistance: HomeCubit.get(context).directions!.totalDistance),
//                                       createdTime: DateTime.now().toString(),
//                                       driverRating: 0,
//                                       userRating: 0,
//                                       driverComment: "none",
//                                       userComment: "none",
//                                       pending: false,
//                                       bannedDrivers: []),
//                                   isLoading: controller.text.isEmpty);
//                             } else {
//                               showToast(
//                                   message:
//                                      "error In Data Please Try Again",
//                                   color: ColorManager.liteRed);
//                             }
//                           }
//                         } else {
//                           showToast(
//                               message: S.of(context).pleaseSelectService,
//                               color: ColorManager.liteRed);
//                         }
//                         ok = true;
//                       },
//                       width: 90.w,
//                       height: 7.h)


 