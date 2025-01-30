class GeneralHelper {

  static String  getBestAddress(List<String> addresses){
  for (var element in addresses) {
    if(!element.contains("+")){
      return element;
    }
  }
  return addresses[0];
}
  static String calculationTotalCash(
      {required int cost,
      required String totalDistance,
      required List<dynamic> serviceTimeList,
      required bool isFreeRide,
      required minimumFare}) {
    //if()

    var datetime = DateTime.now();
      String time = '${datetime.hour}:${datetime.minute}';

if (isFreeRide) {
      for (var serviceTime in serviceTimeList) {
        if (calculationHours(time) >=
                calculationHours(serviceTime['startingTime']) &&
            calculationHours(time) <=
                calculationHours(serviceTime['endingTime'])) {
          if ((serviceTime['costPerKiloInTime']).round().toDouble() <
              minimumFare) {
            return "$minimumFare MRU";
          }
          return "${(serviceTime['costPerKiloInTime'] * double.parse(totalDistance.split("m").first)).round()} MRU";
        }
      }
      return "$cost MRU";
}


    if (totalDistance.contains(",")) {
      if (totalDistance.contains("m")) {
        return "20 MRU";
      }
      totalDistance = totalDistance.replaceAll(',', '');
    }
    if (totalDistance.contains("k")) {
      
      for (var serviceTime in serviceTimeList) {
        if (calculationHours(time) >=
                calculationHours(serviceTime['startingTime']) &&
            calculationHours(time) <=
                calculationHours(serviceTime['endingTime'])) {
          if (!isFreeRide) {
            for (int i = 0; i < serviceTime['listOfKilos'].length; i++) {
              if (double.parse(totalDistance.split(" ").first) >=
                      serviceTime['listOfKilos'][i]['initialDistance'] &&
                  double.parse(totalDistance.split(" ").first) <=
                      serviceTime['listOfKilos'][i]['finalDistance']) {
                return "${(serviceTime['listOfKilos'][i]['costForDistance'])} MRU";
              }
            }
          }
          if ((serviceTime['costPerKiloInTime'] *
                      double.parse(totalDistance.split("km").first))
                  .round()
                  .toDouble() <
              minimumFare) {
            return "$minimumFare MRU";
          }
          return "${(serviceTime['costPerKiloInTime'] * double.parse(totalDistance.split("km").first)).round()} MRU";
        }
      }
    }
    if (totalDistance.contains("k")) {
      if ((cost * double.parse(totalDistance.split("km").first))
              .round()
              .toDouble() <
          minimumFare) {
        return "$minimumFare MRU";
      }
      return "${(cost * double.parse(totalDistance.split("km").first)).round().toString()} MRU";
    }

    return "$minimumFare MRU";
  }

  static double calculationHours(String time) {
    return double.parse(time.split(":").first) +
        double.parse(time.split(":")[1]) / 60;
  }

  static double calculationCostPerKilo({
    required double cost,
    required List<dynamic> serviceTimeList,
    required double totalDistance,
    required bool isFreeRide,
  }) {
   

    var datetime = DateTime.now();
    String time = '${datetime.hour}:${datetime.minute}';

    for (var serviceTime in serviceTimeList) {
      if (calculationHours(time) >=
              calculationHours(serviceTime['startingTime']) &&
          calculationHours(time) <=
              calculationHours(serviceTime['endingTime'])) {
        if (!isFreeRide) {
          for (int i = 0; i < serviceTime['listOfKilos'].length; i++) {
            if (totalDistance >=
                    serviceTime['listOfKilos'][i]['initialDistance'] &&
                totalDistance <=
                    serviceTime['listOfKilos'][i]['finalDistance']) {
              return (
                serviceTime['listOfKilos'][i]['costForDistance']
                      .toDouble() /
                  totalDistance
                  ).round();
            }
          }
        }

        return serviceTime['costPerKiloInTime'].toDouble();
      }
    }
    return cost;
  }

  static double calculationTotalCashDouble(
      {required double cost,
      required String totalDistance,
      required bool isFreeRide,
      required List<dynamic> serviceTimeList,
      required num minimumFare}) {

   var datetime = DateTime.now();
    String time = '${datetime.hour}:${datetime.minute}';

if (isFreeRide) {
          for (var serviceTime in serviceTimeList) {
        if (calculationHours(time) >=
                calculationHours(serviceTime['startingTime']) &&
            calculationHours(time) <=
                calculationHours(serviceTime['endingTime'])) {

          if (minimumFare.toDouble() >
              serviceTime['costPerKiloInTime'].toDouble()) {
            return minimumFare.toDouble();
          }
          return serviceTime['costPerKiloInTime'].toDouble() *
              double.parse(totalDistance.split("km").first);
        }
      }
      return cost;
}


    if (totalDistance.contains(",")) {
      if (totalDistance.contains("m")) {
        return 50;
      }
      totalDistance = totalDistance.replaceAll(',', '');
    }
 


    if (totalDistance.contains('k')) {
      for (var serviceTime in serviceTimeList) {
        if (calculationHours(time) >=
                calculationHours(serviceTime['startingTime']) &&
            calculationHours(time) <=
                calculationHours(serviceTime['endingTime'])) {
          if (!isFreeRide) {
            for (int i = 0; i < serviceTime['listOfKilos'].length; i++) {
              if (double.parse(totalDistance.split(" ").first) >=
                      serviceTime['listOfKilos'][i]['initialDistance'] &&
                  double.parse(totalDistance.split(" ").first) <=
                      serviceTime['listOfKilos'][i]['finalDistance']) {
                return serviceTime['listOfKilos'][i]['costForDistance'];
              }
            }
          }

          if (minimumFare.toDouble() >
              serviceTime['costPerKiloInTime'].toDouble() *
                  double.parse(totalDistance.split("km").first)) {
            return minimumFare.toDouble();
          }
          return serviceTime['costPerKiloInTime'].toDouble() *
              double.parse(totalDistance.split("km").first);
        }
      }
      if (minimumFare.toDouble() >
          cost * double.parse(totalDistance.split("km").first)) {
        return minimumFare.toDouble();
      }
      return (cost * double.parse(totalDistance.split("km").first))
          .round()
          .toDouble();
    }
    return minimumFare.toDouble();
  }

  static String transDistance(String distance) {
    if (distance.contains("km")) {
      distance = distance.replaceAll("km", "كم");
    }
    if (distance.contains("m")) {
      distance = distance.replaceAll("m", "متر");
    }
    return distance;
  }

  static String transDuration(String duration) {
    if (duration.contains("mins")) {
      duration = duration.replaceAll("mins", "دقائق");
    }
    if (duration.contains("min")) {
      duration = duration.replaceAll("min", "دقيقة");
    }
    if (duration.contains("hours")) {
      duration = duration.replaceAll("hours", "ساعات");
    }
    if (duration.contains("hour")) {
      duration = duration.replaceAll("hour", "ساعة");
    }
    return duration;
  }

  static bool isContains(String serviceRegion, String userRegion) {
    List<String> serviceRegionList = serviceRegion.split(",");
    for (var element in serviceRegionList) {
      if (userRegion.contains(element)) {
        return true;
      }
    }
    return false;
  }

  static double getDis(String distance) {
    try {
      if (distance.contains("k")) {
        return double.parse(distance.replaceAll("km", '').trim());
      }
    } catch (e) {
      return 10;
    }
    return 10;
  }
}
//"${(HomeCubit.get(context).services[index].costPerKilo * double.parse(HomeCubit.get(context).directions!.totalDistance.split("km").first)).toString()} UM",


