import 'package:flutter/cupertino.dart';

import '../models/direction.dart';
import '../models/trip_history_model.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickupLocation, userDropOffLocation;

  int countTotalTrips=0;
  String driverTotalEarnings="0";
  String driverAverageRatings="0";

  List<String> historyTripsKeyList=[];
  //
  List<TripsHistoryModel> allTripsHistoryInformationList=[];

  void updatePickupLocationAddress(Directions userPickupAddress){
    userPickupLocation=userPickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress){
    userDropOffLocation=dropOffAddress;
    notifyListeners();
  }
  updateOverAllTripsCounter(int overAllTripsCounter){
    countTotalTrips=overAllTripsCounter;
    notifyListeners();
  }
  updateOverAllTripsKeys(List<String> tripsKeysList){
    historyTripsKeyList=tripsKeysList;
    notifyListeners();
  }
  updateOverAllTripsHistoryInformation(TripsHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }
  updateDriverTotalEarnings(String driverEarnings){
    driverTotalEarnings=driverEarnings;
  }
  updateDriverAverageRatings(String driverRatings){
    driverAverageRatings= driverRatings;
  }
}