import 'package:flutter/cupertino.dart';
import 'package:weight_tracker/model/weight.dart';

class WeightProvider extends ChangeNotifier {

  late Weight _weight =Weight("id", 0, new DateTime.now(), "uid");
  
  bool _loading = true;
  List<Weight> _weightHistory = [];

  bool get loadingWeight => _loading;

  isLoadingWeight(bool value){
    _loading = value;
    notifyListeners();
  }

  List<Weight> get weightHistory => _weightHistory;

  Weight get weight => _weight;

  setWeightHistory(List<Weight> history){
    _weightHistory = history;
    setWeight(history[0]);
    notifyListeners();
  }

  setWeight(Weight weight){
    _weight = weight;
    notifyListeners();
  }

  Weight getWeightByIndex(int i) =>_weightHistory[i];


}