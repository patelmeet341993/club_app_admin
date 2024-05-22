import 'package:club_model/club_model.dart';

class ClubProvider extends CommonProvider {
  ClubProvider(){
    clubList = CommonProviderListParameter<ClubModel>(
      list: [],
      notify: notify,
    );
    lastDocument = CommonProviderPrimitiveParameter<DocumentSnapshot<Map<String, dynamic>>?>(
      value:null,
      notify: notify,
    );
    clubCount = CommonProviderPrimitiveParameter<int>(
      value:0,
      notify: notify,
    );
    hasMoreClub = CommonProviderPrimitiveParameter<bool>(
      value:false,
      notify: notify,
    );
    clubLoading = CommonProviderPrimitiveParameter<bool>(
      value:false,
      notify: notify,
    );
  }

  late CommonProviderListParameter<ClubModel> clubList;
  late CommonProviderPrimitiveParameter<DocumentSnapshot<Map<String, dynamic>>?> lastDocument;
  late CommonProviderPrimitiveParameter<int> clubCount;
  late CommonProviderPrimitiveParameter<bool> hasMoreClub;
  late CommonProviderPrimitiveParameter<bool> clubLoading;

  void addAllClubList(List<ClubModel> value,{bool isNotify = true}) {
    clubList.setList(list: value);
    if(isNotify) {
      notifyListeners();
    }
  }

  void addClubInList(ClubModel value,{bool isNotify = true}) {
    clubList.setList(list: [value],isClear: false);
    if(isNotify) {
      notifyListeners();
    }
  }

  void removeClubFromList(int index,{bool isNotify = true}) {
    clubList.getList().removeAt(index);
    if(isNotify) {
      notifyListeners();
    }
  }



}

