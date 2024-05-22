import 'package:club_model/models/club/data_model/club_operator_model.dart';
import 'package:club_model/club_model.dart';

class ClubOperatorProvider extends CommonProvider {
  ClubOperatorProvider(){
    clubOperatorList = CommonProviderListParameter<ClubOperatorModel>(
      list: [],
      notify: notify,
    );
    lastDocument = CommonProviderPrimitiveParameter<DocumentSnapshot<Map<String, dynamic>>?>(
      value:null,
      notify: notify,
    );
    clubOperatorCount = CommonProviderPrimitiveParameter<int>(
      value:0,
      notify: notify,
    );
    hasMoreClubOperators = CommonProviderPrimitiveParameter<bool>(
      value:false,
      notify: notify,
    );
    clubOperatorsLoading = CommonProviderPrimitiveParameter<bool>(
      value:false,
      notify: notify,
    );
  }

  late CommonProviderListParameter<ClubOperatorModel> clubOperatorList;
  late CommonProviderPrimitiveParameter<DocumentSnapshot<Map<String, dynamic>>?> lastDocument;
  late CommonProviderPrimitiveParameter<int> clubOperatorCount;
  late CommonProviderPrimitiveParameter<bool> hasMoreClubOperators;
  late CommonProviderPrimitiveParameter<bool> clubOperatorsLoading;

  void addAllClubOperatorList(List<ClubOperatorModel> value,{bool isNotify = true}) {
    clubOperatorList.setList(list: value);
    if(isNotify) {
      notifyListeners();
    }
  }

  void addClubOperatorInList(ClubOperatorModel value,{bool isNotify = true}) {
    clubOperatorList.setList(list: [value],isClear: false);
    if(isNotify) {
      notifyListeners();
    }
  }

  void removeClubOperatorFromList(int index,{bool isNotify = true}) {
    clubOperatorList.getList().removeAt(index);
    if(isNotify) {
      notifyListeners();
    }
  }



}
